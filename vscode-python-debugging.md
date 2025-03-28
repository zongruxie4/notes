# vscode python debugging

To debug inside dependencies and visualise them in the call stack, add `"justMyCode": false` to the launch config in _launch.json_. To enable this for all tests:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Python: Debug Tests",
      "type": "debugpy",
      "request": "launch",
      "program": "${file}",
      "purpose": ["debug-test"],
      "console": "internalConsole",
      "justMyCode": false
    }
  ]
}
```

Unfortunately the above only works in _launch.json_ and not in _\*.code-workspace_ or _settings.json_ (see [#18778](https://github.com/microsoft/vscode-python/issues/18778)).

To run scripts installed in the virtualenv, [explicitly add the venv's bin dir to the path](https://github.com/microsoft/vscode-python/issues/4300#issuecomment-1146749781):

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "testing",
      "type": "python",
      "request": "launch",
      "purpose": ["debug-test"],
      "justMyCode": false
      "env": { "PATH": "${workspaceFolder}/.venv/bin"}
    }
  ]
}
```

To run a fastapi/uvicorn app

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "fastapi",
      "type": "python",
      "request": "launch",
      "env": { "API_VERSION": "vscode.debug" },
      "program": "venv/bin/uvicorn",
      "args": ["app.main:app", "--reload"],
      "console": "internalConsole"
    }
  ]
}
```

There are two console modes:

- `"console": "integratedTerminal"` (default) starts a terminal window and runs the program there. Useful if you want to set up environment variables manually in advance.
- `"console": "internalConsole"` avoids creating terminal windows every time you launch

## Attach

Install [debugpy](https://github.com/microsoft/debugpy):

```
pip install debugpy
```

Run your program and wait for connection:

```
python -m debugpy --listen 62888 --wait-for-client <filename> | -m <module> [<arg>]...`
```

`<filename>` can be a path to a _.py_ file or a console script, eg: _.venv/bin/myapp_.

To debug a test called `test_flow`:

```
python -m debugpy --listen 62888 --wait-for-client -m pytest -k test_flow
```

To accept a remote connection, including a connection from a container host, listen on all interfaces:

```
python -m debugpy --listen 0.0.0.0:62888 ...
```

Connect to the debugger using an attach config:

```json
{
  "name": "Python: Remote Attach",
  "type": "debugpy",
  "request": "attach",
  "connect": {
    "host": "localhost",
    "port": 62888
  },
  "pathMappings": [
    {
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "."
    }
  ],
  "justMyCode": false
}
```

## Troubleshooting

> The editor could not be opened because the file was not found.

Make sure you are mapping the cwd of debugpy (ie: remote root) to your workspace.

eg: if running debugpy in a subdir of your workspace folder, use:

```json
            "pathMappings": [
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "../"
                }
            ],
```

or if you are running debugpy in a container with packages installed into _/usr/local/lib_:

```json
            "pathMappings": [
                // map files in /usr/local/lib to the workspace's venv
                {
                    "localRoot": "${workspaceFolder}/.venv/lib/",
                    "remoteRoot": "/usr/local/lib/"
                },
                // map files in cwd to workspace
                {
                    "localRoot": "${workspaceFolder}",
                    "remoteRoot": "."
                }
            ],
```

> Breakpoints aren't being hit

Can happen when `pathMappings` point the remote directory to somewhere other than the workspace directory, eg: if the current directory is not the workspace directory and you have:

```json
            "pathMappings": [
              {
                "localRoot": "${workspaceFolder}",
                "remoteRoot": "."
              }
            ],
```

Try deleting the pathMappings.

> Notebook weirdness

When debugging a notebook I've noticed:

- values change underneath me
- not all code paths are hit

Possibly not seeing all the threads? Use print statements to understand what's going on.

> connect ECONNREFUSED 127.0.0.1:62888

If this happens when using `debugpy` in the terminal, check the terminal doesn't have a yellow warning label to signify the terminal needs to be relaunced see [No-Config Debugging - Troubleshooting](https://github.com/microsoft/vscode-python-debugger/wiki/No%E2%80%90Config-Debugging#troubleshooting)

## References

- [Python debugging in VS Code](https://code.visualstudio.com/docs/python/debugging)
- [Why the debug console uses tab for autocompletion selection](https://github.com/microsoft/vscode/issues/108439#issuecomment-871521843)
