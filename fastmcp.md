# FastMCP

## Task notifications and restart behavior

### SEP-1686

FastMCP implements SEP-1686 background tasks on top of **Docket**.

- Components opt in with `task=True` or `TaskConfig(...)`
- FastMCP advertises `capabilities.tasks`
- Background task requests are routed through component-level task handlers
- FastMCP generates the MCP task ID, stores task metadata/context in Redis, and queues work in Docket
- Clients interact with tasks through `tasks/get`, `tasks/result`, `tasks/cancel`, plus optional `notifications/tasks/status`

### Where task status notifications come from

Docket manages task execution state/events.
FastMCP manages notifications/tasks/status as MCP notifications.

`notifications/tasks/status` are **not emitted directly by Docket**.

Instead:

1. Docket exposes execution events through `execution.subscribe()`
2. FastMCP listens to those events
3. FastMCP translates them into MCP `TaskStatusNotification`
4. FastMCP sends them to the client with `session.send_notification(...)`

FastMCP also sends:

- an initial task `working` notification at submission time
- special `input_required` / elicitation notifications via a separate reliable Redis-backed queue

Docket is responsible for things like:

- queueing the task
- storing execution state/results
- exposing execution events via execution.subscribe()

### Reliable distributed notifications

FastMCP has a Redis-backed queue for worker-to-session delivery in distributed cases.

Pattern:

- one queue per `session_id`
- worker pushes notification payloads to Redis (`LPUSH`)
- server-side subscriber loop reads them (`BRPOP`)
- server forwards them over the live MCP session
- retries up to 3 times on delivery failure

This is mainly used for:

- `input_required` task notifications
- elicitation relay / interactive task flows

It is **not** the main mechanism for ordinary progress updates; those usually come from Docket `execution.subscribe()` and are forwarded by FastMCP.

### Are task progress updates sent via `session.send_notification(...)`?

Yes.

In FastMCP, progress/status updates are sent as MCP `notifications/tasks/status` using `session.send_notification(...)`.

Spec-wise:

- the MCP spec defines `notifications/tasks/status` as an optional task status notification
- FastMCP uses the SDK's `send_notification(...)` to put that protocol notification on the wire
- progress text is represented using the task's `statusMessage`

### What happens when the MCP server restarts?

#### Live sessions do not survive restart

A restart loses all in-process state such as:

- live `ServerSession` objects
- per-task forwarding loops
- per-session notification subscribers
- weakref session registries

Clients must reconnect.

#### Task survival depends on backend

##### `memory://` Docket

- pending tasks are lost on restart
- status stream is lost
- results are lost

##### Redis-backed Docket

- tasks can survive restart
- task metadata/results can survive restart
- clients can reconnect and recover via:
  - `tasks/get`
  - `tasks/result`
  - `tasks/cancel`

#### What is lost after restart?

Even when Redis-backed tasks survive, the **live push notification stream** usually does not automatically resume.

That means:

- existing task can still exist
- polling can still work
- the old `notifications/tasks/status` stream for in-flight tasks is generally lost

Safe recovery path after restart:

1. reconnect client
2. reinitialize session
3. poll with `tasks/get`
4. fetch result with `tasks/result`

Treat polling as authoritative after restart.

### Can `EventStore` help?

**Partially.**

`EventStore` is a transport-layer replay buffer for StreamableHTTP, not a task-subscription durability mechanism.
It stores outbound JSON-RPC messages with event IDs and can replay missed events after reconnect via Last-Event-ID.

What it does **not** do by itself:

- recreate FastMCP's per-task `execution.subscribe()` forwarding loop
- automatically resume future push notifications for tasks already running before restart

So EventStore helps with **replaying old emitted events**, not with **restarting the live producer of new task status notifications**.

### Practical matrix

| Setup                                                           | Task survives restart? | Past status notifications replayable? | Future push status notifications for already-running task resume automatically? |
| --------------------------------------------------------------- | ---------------------: | ------------------------------------: | ------------------------------------------------------------------------------: |
| `memory://` Docket                                              |                     No |                                    No |                                                                              No |
| Redis-backed Docket                                             |                    Yes |                                    No |                                                                              No |
| Redis-backed Docket + persistent `EventStore` on StreamableHTTP |                    Yes |    Yes, if already emitted and stored |                                                                              No |

### Bottom line

- Task survives restart depends on Docket backend persistence.
- Past status notifications replayable depends on:
  - StreamableHTTP transport
  - EventStore configured
  - persistent EventStore backend
  - the notifications having already been sent/stored before restart
- Future push notifications resume automatically is still No because the FastMCP process-local task subscription/forwarding loop is not automatically rebuilt for pre-existing in-flight tasks after restart.

#### Safe recovery strategy

After restart:

1. reconnect client
2. reinitialize session
3. use:
   - tasks/get
   - tasks/result
   - tasks/cancel

Treat push notifications as best-effort, and polling as authoritative.

## Stateful vs stateless HTTP

| Feature                                                    |                       Stateful HTTP |                        Stateless HTTP |
| ---------------------------------------------------------- | ----------------------------------: | ------------------------------------: |
| Normal tool calls                                          |                                 Yes |                                   Yes |
| Streaming response within a request                        |                                 Yes |                                   Yes |
| `ctx.report_progress()` during an active tool call         |                                 Yes |                                   Yes |
| Stable `ctx.session_id` across calls                       |                                 Yes |                                    No |
| In-memory session state across calls                       |                                 Yes |                                    No |
| `on_initialize` state visible to later calls               |                                 Yes |  Not as built-in server session state |
| GET SSE stream endpoint                                    |                                 Yes |                                    No |
| Server-initiated notifications across requests/session     |                                 Yes |                                    No |
| Elicitation                                                |                                 Yes |                                    No |
| FileUpload default session scoping                         |                                 Yes |                                    No |
| EventStore resumability / replay                           |                                 Yes | No practical session channel for this |
| Multi-worker / horizontally scaled deployment friendliness | Lower unless session affinity works |                                Higher |

### Key clarification

- Stateless HTTP **does support progress notifications**
- but only **while the current request is open**
- it does **not** give you a persistent session channel for later notifications
