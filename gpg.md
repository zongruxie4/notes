# gpg

Generate key in ~/.gnupg/

```
gpg --full-generate-key
```

List fingerprints of keys:

```
gpg --fingerprint
```

Extract fingerprint for use in scripts:

```bash
GPG_FINGERPRINT=$(gpg --list-keys --with-colons $uid | awk -F: '/^fpr:/ {print $10; exit}')
```

Export private key:

```bash
gpg --armor --export-secret-keys $uid
```

Delete all keys:

```bash
# Delete all secret keys first
gpg --list-secret-keys --keyid-format LONG --with-colons | grep -E "^fpr:" | awk -F: '{print $10}' | xargs -I {} gpg --batch --yes --delete-secret-keys {}
# Then delete all public keys
gpg --list-keys --keyid-format LONG --with-colons | grep -E "^fpr:" | awk -F: '{print $10}' | xargs -I {} gpg --batch --yes --delete-keys {}
```
