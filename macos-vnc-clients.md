# macOS VNC Clients

## Server side resizing

> The client can request changes to the framebuffer size and screen layout. The server is free to approve or deny these requests at will, but must always inform the client of the result.

See [SetDesktopSize](https://github.com/rfbproto/rfbproto/blob/master/rfbproto.rst#setdesktopsize) and [ExtendedDesktopSize Pseudo-encoding](https://github.com/rfbproto/rfbproto/blob/master/rfbproto.rst#extendeddesktopsize-pseudo-encoding).

If the server doesn't support this, then the client will be stuck with the resolution (size) provided by the server. wayvnc and hyprland don't support this when connecting to a real monitor, but do [in headless mode](https://github.com/Zellington3/Ghost-Monitor-Wayvnc-Hyprland/tree/main).

If the resolution is large, clients will render with scroll bars. RealVNC support client-side scaling.

To adjust the server size resolution see [this comment](https://github.com/basecamp/omarchy/discussions/1284#discussioncomment-14418697).

## Screen Sharing

The built-in macOS Screen Sharing app cannot connect to `wayvnc`.

## TigerVNC

Install with:

```bash
brew install --cask tigervnc-viewer
```

## RealVNC

RealVNC can resize on the client using using the **Window > Fill** menu item. You must provide the port when connecting.

Install with:

```bash
brew install --cask vnc-viewer
```

## TurboVNC

TurboVNC can resize on the client using Zoom In and Zoom Out or by setting `Connection - Display - Scaling Factor`. Setting this to `Auto` will resize on the client to fit the window.

To resize the server, set `Connection - Display - Remote desktop size`. Setting this to `Auto` will resize on the server to fit the window.

Install with:

```bash
brew install --cask turbovnc-viewer
```
