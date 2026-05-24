# macos privacy & security

Get app bundle id:

```sh
osascript -e 'id of app "Cursor"'
com.todesktop.230313mzl4w4u92
```

If an app was previously denied and isn't asking again, you can reset its TCC status via terminal to force a new permission dialogue:

```sh
tccutil reset SystemPolicyDownloadsFolder com.todesktop.230313mzl4w4u92 # cursor
```
