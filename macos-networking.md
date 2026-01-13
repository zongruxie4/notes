# macOS networking

Routing tables:

```
netstat -rn
```

Internet sockets open by processes owner by current user:

```
lsof -i -P -n
```

Owned by any user:

```
sudo lsof -i -P -n
```

## Troubleshooting

### Service not listening on 127.0.0.1 but listening on \[::1\]

Check:

```
❯ lsof -i -P -n | grep LISTEN | grep 6333
Code\x20H  2866 tekumara   35u  IPv4 0xf7bb05b97fb537c3      0t0  TCP 127.0.0.1:6333 (LISTEN)
com.docke 40002 tekumara  182u  IPv6 0xf7bb05be4bcbb5db      0t0  TCP *:6333 (LISTEN)DSZ
```

VS Code is taking the IPv4 port.

### ssh: connect to host myhost.local port 22: Undefined error: 0

Allow the popup:

```
Allow "WezTerm" to find devices
on local networks?

This will allow the app to discover,
connect to and collect data from
devices on your networks.
```

Or Under Settings - Privacy & Security - Local Network enable the application.

### ssh: connect to host myhost.local port 22220: No route to host

This can happen in VS Code when connecting to hosts on the local network. Same solution as above.
