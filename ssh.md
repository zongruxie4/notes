# ssh

## Passwordless login with SSH keys

Create a key on the client:

```
ssh-keygen -t ed25519 -C "you@example.com"
```

Copy the public key to the server:

```
ssh-copy-id user@server
```

If `ssh-copy-id` is unavailable:

```
cat ~/.ssh/id_ed25519.pub | ssh user@server 'mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys'
```

Test:

```
ssh user@server
```
