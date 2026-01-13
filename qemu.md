# qemu

qemu-base is headless

qemu-desktop = qemu-base + UI, audio, spice
qemu-full = qemu-desktop + multiple archs

## Install

Use qemu-desktop + the git master branch to get latest fixes:

```
yay -Sy qemu-desktop quickemu-git
```

## quickget

Download Windows ISO, create unattended install with virtio drivers and spice, and a qemu conf file:

```
quickget windows 11
```

Automatically logs in as `Quickemu` user (password is `quickemu`).

If you see

> Microsoft blocked the automated download request based on your IP address.

Then manually download the latest ISO using the [direct download links for Windows 11 25H2](https://pureinfotech.com/windows-11-25h2-enablement-package-iso-direct-download/).

Windows 11 will consume 8G RAM and 14GB qcow2 disk space (~35GB in Windows) on a fresh install.

## quickemu

Start:

```
quickemu --vm windows-11.conf
```

Kill:

```
quickemu --vm windows-11.conf --kill
```

Full-screen (sdl display): `CTRL+ALT+F`

Headless:

```
quickemu --vm windows-11.conf --display none
```

### Spice

To share clipboard requires using spice:

```
quickemu --vm windows-11.conf --display spice
```

Full-screen (spice display): `Shift+F11`
Release cursor and return to host: `Shift+F12`

Spice has a higher resolution display than sdl.

If `Options - Resize guest to match window size` is enabled, the display resolution will change as the host window size changes. This overrides any display resolution set within the guest. Disable this before trying to set the display resolution inside Windows.

### ssh

1. [Enable OpenSSH Server](windows-setup.md#enable-openssh-server) on the Windows guest.
1. From the host: `ssh -v quickemu@localhost -p 22220` password: quickemu. Port is shown when quickemu starts. Will drop you into an Administrator terminal.

## Networking

### Port forwarding

In .conf add, for example:

```
port_forwards=("47984:47984" "47989:47989" "47990:47990" "48010:48010" "47998:47998/udp" "47999:47999/udp" "48000:48000/udp")
```

These will expose the ports to the host, but not the local network. Local network access requires a bridge.

## Diagnostics

### Logs

`quickemu` redirects QEMU output to a log file in the VM directory:

- Log file: `[vm-name].log` (e.g. `windows-11.log`)
- Command line: `[vm-name].sh` contains the full `qemu` command used to start the VM.
- Ports: `[vm-name].ports` shows the SSH and SPICE ports.
