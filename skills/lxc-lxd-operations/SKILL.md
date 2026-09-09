---
name: lxc-lxd-operations
description: Use when working with LXD-managed LXC containers, especially when inspecting, provisioning, debugging, networking, or operating containers across local or configured remote LXD hosts. Discover the actual remotes, profiles, networks, and topology before acting; use the existing layout; require operator approval before disruptive, destructive, externally exposing, or firewall-changing actions.
---

# LXC/LXD Operations

Use `lxc`, the LXD client, for normal administration. LXC is the underlying
container technology; do not manipulate liblxc state or LXD's storage tree
directly.

## Operating contract

Treat the environment as an existing system, not a blank installation:

- LXD is initialized and operational, with one or more profiles and networks
  already defined.
- Containers are provisioned from images and configured through profiles and
  per-instance config, not by editing LXD's internals.
- Containers on the same LXD-managed bridge normally reach one another directly
  by container IP.
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

Record, at minimum: default remote, candidate host remotes, profiles in use, the
instance's NIC and network, bridge subnet and gateway, target instance/IP,
service port, and whether the service is intended for internal, LAN, or WAN
access.

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
- LXD proxy devices, host port exposure, ingress changes, WAN exposure, and any UFW/firewall command.
- Copying or moving data/instances between hosts when it could expose secrets, overwrite a destination, or consume substantial storage/bandwidth.

Before approved destructive work, take a named regular snapshot when practical
and confirm that the snapshot is complete. A snapshot is not a backup. Do not
claim rollback safety without verifying the relevant data is included.

## Networking and web services

Containers on the same bridge reach one another by container IP, which is
sufficient for most internal service-to-service traffic. Discover which
container (if any) acts as ingress before assuming a topology.

For external HTTP/HTTPS access, the common patterns are a reverse-proxy
container in front of the service, or an LXD `proxy` device mapping a host port
to a container port. Either is an exposure change and needs approval. A proxy
device may also require a host firewall rule. If it does, stop and escalate: the
agent cannot perform or assume those host changes. Give the operator the concise
UFW commands in `reference/networking.md`, using the actual discovered addresses
and ports, and explain the permitted source and destination.

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
listening sockets, service status, container-to-container reachability, then
LXD logs. This separates a stopped service from a listening service, an internal
routing failure, a configuration problem, and an external ingress problem. See
`reference/troubleshooting.md` for the exact sequence.

Official references:

- https://linuxcontainers.org/lxc/documentation/
- https://canonical.com/lxd/docs/latest/reference/