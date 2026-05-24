# zed

Start in foreground to see logging:

```
zed --foreground # mac
zeditor --foreground # linux
```

## Language servers

Won't start if:

- the workspace is in restricted mode.
- the lsp server crashes on startup. If the server doesn't appear in the list of Language Servers it might have crashed. Wait a bit util you see an error
