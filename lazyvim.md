# lazyvim

In LazyVim, the leader key is `<Space>` (spacebar).

## Plugins

`<Space>l` to open the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager.

Within the manager use `C` (Check) to list plugins.

## Terminal

Powered by the [Snacks terminal](https://github.com/folke/snacks.nvim/blob/main/docs/terminal.md).

For help see `:help snacks-terimal` which displays [snacks.nvim-terminal.txt](https://github.com/folke/snacks.nvim/blob/main/doc/snacks.nvim-terminal.txt).

`<Space>ft` - terminal in root dir

To enter normal mode from terminal mode use double esc or `Ctrl+\` `Ctrl+n` and then `i` to return to terminal mode.

## Picker

The [find files picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md) is from snacks.nvim.

See how to [show hidden files](https://github.com/LazyVim/LazyVim/discussions/6807#discussioncomment-15038023) in the picker and explorer.

## Explorer

The file [explorer](https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md) is also part of snacks.nvim.

`H` show hidden files press.  
`a` create a new file.  
`r` rename file.

See also:

- [The New Snacks Picker](https://buttondown.com/dustyphillipscodes/archive/the-new-snacks-picker/) - compares Telescope and fzf.lua
- [4.3. The Snacks Explorer Plugin](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-4/#_the_snacks_explorer_plugin)
- [Neotree](https://github.com/nvim-neo-tree/neo-tree.nvim) is an alternative to the snacks explorer.

## Notifications

Show as temporary popups using [noice.nvim](https://github.com/folke/noice.nvim).

To see notification history `:Noice`

## Mason

Open with `<Space>cm`.

For more info see [10.2 Mason.nvim](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-10/#_mason_nvim).

## LSP

`<Space>ca` - show code actions for diagnostics on the current line.

`:checkhealth vim.lsp` health check and view lsp config

## Window resize

In Normal mode:

`Ctrl+w +` - Increase height  
`Ctrl+w -` - Decrease height
`Ctrl+w >` - Increase width  
`Ctrl+w <` - Decrease width

You can also specify a number before the command (e.g., 10 Ctrl+w + to increase height by 10 lines).

## Clipboard

LazyVim defaults to copying and pasting from the system clipboard using `unnamedplus`, except when OSC52 is enabled [because it can be slow](https://github.com/neovim/neovim/issues/29504#issuecomment-2226374704).

See also https://github.com/LazyVim/LazyVim/discussions/4602

## Keymaps

See

- [Default keymaps](https://www.lazyvim.org/configuration/general)

## Navigation

### Switch between panes

- `Ctrl+h` - Move to left pane
- `Ctrl+j` - Move to bottom pane
- `Ctrl+k` - Move to top pane
- `Ctrl+l` - Move to right pane

Or use the traditional Vim commands:

- `Ctrl+w` `h/j/k/l` - Move left/down/up/right
- `Ctrl+w` `w` - Cycle to next window
- `Ctrl+w` `p` - Go to previous window

Buffers (rendered as tabs):

`L` - previous buffer.
`H` - next buffer.
`<Space>bd` - close buffer.

See [Tips - Navigating around multiple buffers](https://www.lazyvim.org/configuration/tips#navigating-around-multiple-buffers).

## Disable lazyvim

Run `nvim --clean`

## Resources

- [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/course/chapter-1/)
