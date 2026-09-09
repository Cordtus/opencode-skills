# LXD Command Reference

Use an explicit `<remote>:<instance>` whenever more than one host is possible.
Omit the remote only after confirming `lxc remote get-default`.

## Discovery

```bash
lxc remote get-default
lxc remote list -f json
lxc list -f json
lxc info <remote:instance>
lxc info <remote:instance> --show-log
lxc config show <remote:instance> --expanded
lxc config device list <remote:instance>
lxc config device show <remote:instance>
lxc profile list
lxc profile show default
lxc network list
lxc network show <network>
lxc storage list
lxc storage show <pool>
lxc image list
```

## Lifecycle and execution

```bash
lxc start <remote:instance>
lxc stop <remote:instance>
lxc restart <remote:instance>
lxc pause <remote:instance>
lxc unpause <remote:instance>
lxc exec <remote:instance> -- <command>
lxc shell <remote:instance>
```

Prompt before disruptive lifecycle actions where service availability or data
state may be affected, including start, stop, restart, pause, and unpause on an
existing instance. Prompt before a file push that can overwrite an existing
path. Use `lxc exec` for automation and `lxc shell` for manual investigation.

## Files and configuration

```bash
lxc file push [-p] <local> <remote:instance>/<path>
lxc file push -r <local-dir> <remote:instance>/<path>
lxc file pull <remote:instance>/<path> <local>
lxc file pull -r <remote:instance>/<path> <local>
lxc config get <remote:instance> <key>
lxc config set <remote:instance> <key> <value>
lxc config unset <remote:instance> <key>
lxc config edit <remote:instance>
```

Inspect before editing. Prompt before all mutating configuration commands and
preserve unrelated keys/devices.

## Storage, snapshots, and host transfers

```bash
lxc storage volume list <pool>
lxc storage volume show <pool> <volume>
lxc snapshot <remote:instance> <name>
lxc restore <remote:instance> <name>
lxc delete <remote:instance>/<snapshot>
lxc export <remote:instance> <backup-file>
lxc import <backup-file>
lxc copy <source-remote:instance> <destination-remote:instance>
lxc move <source-remote:instance> <destination-remote:instance>
```

`copy` preserves the source; `move` does not. Prompt before restore, deletion,
move, volume changes, or transfers with overwrite, secrecy, or resource impact.