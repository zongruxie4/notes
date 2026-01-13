# windows openssh server

## Enable OpenSSH Server

See [Invoke-WinUtilSSHServer.ps1](https://github.com/ChrisTitusTech/winutil/blob/69233b1d8a15b8e1833bc18eab733572b6c4ec34/functions/private/Invoke-WinUtilSSHServer.ps1#L21)

## Configure

Get [default shell](https://github.com/PowerShell/Win32-OpenSSH/wiki/DefaultShell):

```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell
```

Set [default shell](https://github.com/PowerShell/Win32-OpenSSH/wiki/DefaultShell) to git bash:

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\Git\bin\bash.exe" -PropertyType String -Force
```

NB: this won't work with VS Code remote ssh see [#11388](https://github.com/microsoft/vscode-remote-release/issues/11388).

Set default shell to Windows PowerShell:

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
```

Set default shell to PowerShell:

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Program Files\PowerShell\7\pwsh.exe" -PropertyType String -Force
```

or via if you're running this from `cmd.exe`:

```sh
pwsh -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Program Files\PowerShell\7\pwsh.exe' -PropertyType String -Force"
```

Remove setting:

```powershell
Remove-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell
```

## Connect without password

To connect without a password as a [non-admin user](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#standard-user), copy public keys over:

```sh
ssh-copy-id -s windows-host
```

If you are an [admin user](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement#administrative-user), use this:

```sh
cat ~/.ssh/id_ecdsa.pub | ssh windows-host "powershell -NoProfile -Command \"Add-Content -Force -Path \$env:ProgramData\ssh\administrators_authorized_keys -Value ([Console]::In.ReadToEnd()); icacls.exe \$env:ProgramData\ssh\administrators_authorized_keys /inheritance:r /grant 'Administrators:(F)' /grant 'SYSTEM:(F)'\""
```
