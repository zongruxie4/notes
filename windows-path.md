# windows path

## Registry

Get system path:

```powershell
Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name "Path"
```

Get user path:

```powershell
Get-ItemProperty -Path "HKCU:\Environment" -Name "Path"
```

## PATH env var

Get path:

```powershell
$env:PATH
```

Windows constructs `$env:PATH` from the registry, concatenating `[System Path];[User Path]`.

## Setting the user path

`setx` will set the **user** path in the registry.

To avoid duplicating the system path into the user path, use:

```powershell
setx PATH "$([Environment]::GetEnvironmentVariable('Path','User'));C:\Program Files\Git\usr\bin"
```

Alternatively, use [.NET SetEnvironmentVariable](https://learn.microsoft.com/en-us/dotnet/api/system.environment.setenvironmentvariable?view=net-10.0):

```powershell
$oldPath = [Environment]::GetEnvironmentVariable("Path", "User"); [Environment]::SetEnvironmentVariable("Path", "$oldPath;C:\Program Files\Git\usr\bin", "User")
```

### System Path

Setting the system path requires **Administrator** privileges.

Using `setx` with the `/M` flag:

```powershell
setx /M PATH "$([Environment]::GetEnvironmentVariable('Path','Machine'));C:\Program Files\Git\usr\bin"
```

Using .NET:

```powershell
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine"); [Environment]::SetEnvironmentVariable("Path", "$oldPath;C:\Program Files\Git\usr\bin", "Machine")
```

### Removing from path

To remove a directory from the system path:

```powershell
$dirToRemove = "C:\Program Files\Git\usr\bin"
$oldPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$newPath = ($oldPath -split ';' | Where-Object { $_ -ne $dirToRemove }) -join ';'
[Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
```
