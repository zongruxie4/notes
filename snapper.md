# snapper

List configs

```
snapper list-configs
```

List snapshots

```
sudo snapper list
```

Create snapshot

```
sudo snapper -c root create --description "manual snapshot"
```

Show files changes between snapshot 9 and the current state:

```
sudo snapper -c home status 9..0
```

Show diff of .bash_history contents between snapshot 9 and the current state

```
sudo snapper -c home diff 9..0  ~/.bash_history
```

Undo changes made between and the current state, ie: reverts current state to 9:

```
sudo snapper -c home undochange 9..0
```

Sync with boot loader

```
limine-snapper-sync
```

## Deletions

Blocks are kept whilst there are still pointers to them from a snapshot.

So to reclaim disk space, delete the snapshots that point to that block. Snapshots do not rely on each other in a chain, so it's safe to delete earlier snapshots if you no longer need them.

Delete old snapshots:

```
sudo snapper delete 1-49 --sync
```

Btrfs normally asynchronously frees space after deleting snapshots. With the `--sync` option snapper will wait until the space once used by the deleted snapshots is actually available again.

Instead of `--sync` you can trigger the cleanup service:

```
sudo systemctl start snapper-cleanup.service
```
