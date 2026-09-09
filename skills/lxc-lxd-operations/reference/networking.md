# Networking And Exposure

## Layout

LXD-managed bridges are host-local and are not the physical LAN. Treat their
addresses as host-local until `lxc network show <network>` and the effective
instance configuration prove otherwise. Containers sharing a bridge normally
communicate by container IP without an extra NIC.

## Exposing a service

For an HTTP/HTTPS service:

1. Discover the target IP and listening port.
2. Verify the process with `lxc exec <instance> -- ss -lntup`.
3. Test from another container on the same bridge: `lxc exec <peer> -- curl -v http://<target-ip>:<port>/`.
4. Determine the existing ingress path (reverse-proxy container, host proxy, or none) before choosing an exposure mechanism.
5. Prompt for approval before changing any exposure.
6. Verify the internal path and the intended LAN/WAN hostname after the change.

Keep databases and internal services on the bridge without public exposure.

## Reverse proxy

If the layout already has a reverse-proxy container, route HTTP/HTTPS through it
rather than adding a proxy device. Discover its instance name and current
configuration first.

## Proxy-device exception

Use an LXD proxy device only for a confirmed requirement a reverse proxy cannot
satisfy (non-HTTP protocols, no reverse proxy present, or explicit host-port
mapping needed):

```bash
lxc config device add <instance> <device> proxy \
  listen=tcp:<listen-address>:<listen-port> \
  connect=tcp:<target-address>:<target-port>
```

This command requires approval. It may expose a host port and may require a
host firewall rule. The agent must not run the firewall change or imply that the
port is reachable externally without operator verification.

## Operator UFW escalation

After discovering the real source address and chosen host port, the operator
can run these from the host's default shell. Replace the example values before
execution:

```bash
SOURCE_IP="192.0.2.10"
HOST_PORT="8080"
sudo ufw allow from "$SOURCE_IP" to any port "$HOST_PORT" proto tcp
sudo ufw status numbered
```

For a deliberately public TCP port, the operator must explicitly choose the
source range, then run:

```bash
SOURCE="203.0.113.0/24"
HOST_PORT="8080"
sudo ufw allow from "$SOURCE" to any port "$HOST_PORT" proto tcp
sudo ufw status numbered
```

Use the narrowest source and port possible. The agent must report the exact
values it recommends, the security impact, and that the operator owns this
firewall step. If the host uses a different firewall (firewalld, iptables,
nftables), adapt the commands accordingly. Removal also requires approval:

```bash
sudo ufw status numbered
sudo ufw delete <rule-number>
```