# Windows setup

A basic Windows 10 setup with the Windows SDK, scoop, rust needs ~50 GB.

## Win11Debloat

Run [Raphire/Win11Debloat](https://github.com/Raphire/Win11Debloat).

Will remove [these apps](https://github.com/Raphire/Win11Debloat/blob/master/Appslist.txt) and make some config changes.

## Packages

```
winget install -e --id Git.Git
winget install -e --id Neovim.Neovim
winget install -e --id=astral-sh.uv
winget install -e --id tekumara.gh-doctor
winget install -e --id ezwinports.make
winget install -e --id JesseDuffield.lazygit
```

NB: restart the shell to get an updated path with nvim etc.

To include Git bash's unix tools (`ls`, `grep`, etc.) in the system path (ie: for all users) permanently:

```powershell
setx /M PATH "$([Environment]::GetEnvironmentVariable('Path','Machine'));C:\Program Files\Git\usr\bin"
```

[Microsoft C++ Build Tools](https://gist.github.com/robotdad/83041ccfe1bea895ffa0739192771732). For Python C++ extensions, use the Desktop C++ workload:

```
winget install -e --id Microsoft.VisualStudio.2022.BuildTools --override "--wait --passive --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended"
```

## Enable OpenSSH Server

See [windows-openssh-server.md](windows-openssh-server.md).

## Create a non-admin user

Settings - Accounts - Other Users - Add account - I don't have this person's sign-in information - Add a user without a Microsoft account
