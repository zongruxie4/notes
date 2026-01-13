# pacman

## Search

Search **installed** packages containing `nvidia` in name or description

```
pacman -Qs nvidia
```

Search for packages in the sync databases (includes uninstalled) containing regex `stow` in name or description:

```
pacman -Ss stow
```

List files installed by broadcom-wl:

```
pacman -Ql broadcom-wl
```

Show packages out of date:

```
pacman -Qu
```

## Install package

Refresh package database from server

```
sudo pacman -Sy
```

Install a package:

```
sudo pacman -S package_name
```

Uninstall nvidia and dependencies, don't keep backups of anything:

```
sudo pacman -Rns nvidia-dkms
```

## Upgrades

Full system upgrade:

```
sudo pacman -Syu
```

Install a package (and upgrade system to avoid partial upgrade issues):

```
sudo pacman -Syu package_name
```

[Partial upgrades](https://wiki.archlinux.org/title/System_maintenance#Partial_upgrades_are_unsupported) are unsafe, ie: don't use `pacman -Sy package`. Instead do a full system upgrade, or install without refresh using `pacman -S`.

This is because `pacman -Sy` updates the local package database. If you then install a package, it might pull in a newer version of a shared library that other installed packages depend on. Since you didn't upgrade the rest of the system (no `-u`), those other packages remain at their old versions but are now linked against a newer, potentially incompatible library, leading to broken binaries.

## Cache

Packages are cached in /var/cache/pacman/pkg

Remove old versions, keep current ones in cache: `sudo pacman -Sc`
Remove everything from cache (most aggressive; forces re-downloads later): `sudo pacman -Scc`

## Make dependencies

When a package has a make dependency it is needed to build the package, but not install it.

eg: broadcom-wl dependencies are:

> linux
> broadcom-wl-dkms=6.30.223.271 (_make_)
> linux-headers (_make_)

ie: it is built from broadcom-wl-dkms, but this isn't added during install.
