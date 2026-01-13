# terminal

## modify other keys

> Tells xterm to construct an escape sequence for ordinary (i.e., "other") keys (such as "2") when modified by Shift-, Control-, Alt- or Meta-modifiers.

See [modifyOtherKeys on the xterm man page](https://man.openbsd.org/xterm#modifyOtherKeys).

Enable:

```
printf '\x1b[>4;2m'
```

Disable:

```
printf '\x1b[>4;0m'
```

The alternative is the kitty protocol, see [Neovim - Tui](https://neovim.io/doc/user/tui.html#tui-input).
