---
name: lxc-lxd-operations
description: Use when working with LXD-managed LXC containers, especially when inspecting, provisioning, debugging, networking, or operating containers across local or configured remote LXD hosts. Establish the actual remotes, default profile, bridge, and reverse-proxy topology before acting; use the existing layout; require operator approval before disruptive, destructive, externally exposing, or firewall-changing actions.
---

# LXC/LXD Operations

Use `lxc`, the LXD client, for normal administration. LXC is the underlying
container technology; do not manipulate liblxc state or LXD's storage tree
directly.

## Operating contract

Treat the local environment as an existing system, not a blank installation:

- LXD is initialized and operational.
- The environment has a default profile with an LXD-managed bridge network.
- A designated reverse-proxy container (commonly named `caddy` or similar) is
  the normal HTTP/HTTPS ingress/egress path.
- Containers sharing a bridge normally reach one another directly by container
  IP.
- Configured `lxc` remotes may represent additional LXD hosts; use explicit
  remote prefixes for consequential work.

These are assumptions to verify, not facts to rely on. Never infer names, IPs,
ports, profiles, storage pools, or remote roles. Discover them and write the
observed topology into the task notes before relying on it. If the observed
system conflicts with an assumption, the observed system wins and the
discrepancy must be reported.

## First pass: learn the layout

Run read-only discovery, preferably with structured output where supported:

```bash
lxc remote get-default
lxc remote list -f json
lxc list -f json
lxc profile show default
lxc network list
lxc storage list
```

For a target instance, inspect the effective configuration and devices:

```bash
lxc info <remote:instance>
lxc config show <remote:instance> --expanded
lxc config device show <remote:instance>
```

Record, at minimum: default remote, candidate host remotes, the default
profile's NIC/network, bridge subnet and gateway, the reverse-proxy container's
instance/IP, target instance/IP, service port, and whether the service is
intended for internal, LAN, or WAN access.

## Safe workflow

1. Identify the exact remote and instance. Prefer `remote:instance` for multi-host work.
2. Inspect current state, expanded config, inherited devices, network, and storage.
3. State the intended change, affected instance/host, exposure, and rollback path.
4. Ask for confirmation before any approval-gated action below. Include the exact command(s) and expected impact.
5. Make the smallest change possible; preserve unrelated configuration and devices.
6. Verify state, service health, network reachability, and exposure after the change.
7. Report observed results, commands run, and any operator action still required.

Read-only inspection and non-mutating tests may proceed without prompting.

## Approval gates

Prompt immediately before each relevant action, not once for an entire vague
plan. The prompt must identify the target and command. Require explicit consent
for:

- `delete`, `delete -f`, `stop -f`, `restore`, `move`, and removing snapshots, devices, volumes, or profiles.
- Starting, stopping, restarting, pausing, or unpausing an existing instance when service state or availability may change.
- File pushes that overwrite an existing path, or changes to production services when downtime or state loss is possible.
- `lxc config set`, `unset`, `edit`, device add/remove/set, profile changes, storage changes, image publication, and instance creation when they alter an existing system or consume resources.
- Host bind mounts, privileged/raw/physical devices, nesting/security changes, and broad configuration replacement.
- LXD proxy devices, host port exposure, reverse-proxy ingress changes, WAN exposure, and any UFW/firewall command.
- Copying or moving data/instances between hosts when it could expose secrets, overwrite a destination, or consume substantial storage/bandwidth.

Before approved destructive work, take a named regular snapshot when practical
and confirm that the snapshot is complete. A snapshot is not a backup. Do not
claim rollback safety without verifying the relevant data is included.

## Networking and web services

For ordinary services use:

```text
LAN/WAN -> reverse-proxy container -> target-container-IP:service-port
```

First test the service from the reverse-proxy container:

```bash
lxc exec <proxy-container> -- curl -v http://<target-ip>:<port>/
```

Use an LXD `proxy` device only when the reverse-proxy container cannot handle
the requirement or the protocol is not suitable for it. A proxy device is an
exposure change and needs approval. If it requires host firewall changes, stop
and escalate: the agent cannot perform or assume those host changes. Give the
operator the concise UFW commands in `reference/networking.md`, using the actual
discovered addresses and ports, and explain the permitted source and
destination.

Do not add a second NIC or expose a container directly merely to enable
container-to-container communication. Do not treat a bridge IP as LAN-routable
without verifying the actual network configuration.

## Common command patterns

```bash
lxc launch <image> <instance>                 # approval before provisioning
lxc init <image> <instance>                   # approval before provisioning
lxc start <remote:instance>
lxc stop <remote:instance>                    # prompt if disruptive
lxc exec <remote:instance> -- <command>
lxc shell <remote:instance>
lxc file push <local> <remote:instance>/<path>
lxc file pull <remote:instance>/<path> <local>
lxc snapshot <remote:instance> <name>         # prompt if it consumes material resources
```

For shell syntax inside a container, use `lxc exec ... -- sh -c '...'`. Prefer
JSON/YAML output to parsing human-formatted tables. See
`reference/commands.md` for the compact command matrix and
`reference/networking.md` for topology and firewall escalation.

## Troubleshooting order

Check instance state, expanded configuration, devices, addresses/routes,
listening sockets, service status, reverse-proxy-to-target connectivity, then
LXD logs. This separates a stopped service from a listening service, an internal
routing failure, a reverse-proxy configuration problem, and an external ingress
problem. See `reference/troubleshooting.md` for the exact sequence.

Official references:

- https://linuxcontainers.org/lxc/documentation/
- https://canonical.com/lxd/docs/latest/reference/