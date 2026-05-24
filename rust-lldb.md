# rust lldb

eg: `rust-lldb ./target/debug/guessing-game`

`b main.rs:21` - set breakpoint  
`br list` - breakpoint list  
`r` - start execution  
`print guess` - print variable _guess_ as string
`? guess` - show variable _guess_
`n` - step over  
`c` - continue execution  
`fr v` - show all local variables  
`thread list`

Example tracing a [segmentation fault using lldb](https://github.com/pyenv/pyenv/issues/3177).
