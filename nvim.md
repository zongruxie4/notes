# nvim

## Clipboard on remote hosts

When running nvim on a remote host it doesn't have direct access to the guest's clipboard. OSC52 are ANSI escape sequences which are interpreted by the terminal emulator (eg: ghostty) as clipboard commands. This capability is bundled in nvim and enabled when using SSH, the terminal supports it, and no clipboard provider is set (see `:h clipboard-osc52`).

Run `:checkhealth` to see if OSC52 is enabled, eg:

```
OK Clipboard tool found: OSC 52
```

When OSC52 is enabled use `"+y` to copy to the system clipboard and `"+p` to paste.

### Terminal copy/paste

CTRL+V will work regardless, because it doesn't go via the nvim clipboard mechanism.

## Editing

### Commenting

In NeoVim, use the [built in](https://github.com/neovim/neovim/pull/28176) `gc` operator.

**Visual mode:**

1. Select lines with `V` (visual line mode)
2. Press `gc` to toggle comment

**Normal mode:**

- `gcc` - Toggle comment on current line
- `gc2j` - Comment current line + 2 lines below
- `gc4k` - Comment current line + 4 lines above
- `gcap` - Comment around paragraph
- `gcG` - Comment from current line to end of file

**Uncomment:**
Same commands work to toggle - `gc` on commented lines will uncomment them.

**Block comments:**

- `gbc` - Toggle block comment (in visual mode)
- `gbb` - Toggle block comment on current line
