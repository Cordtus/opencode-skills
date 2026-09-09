# Troubleshooting Sequence

Run these read-only checks in order and retain the outputs relevant to the
failure:

```bash
lxc list
lxc info <remote:instance>
lxc config show <remote:instance> --expanded
lxc config device show <remote:instance>
lxc exec <remote:instance> -- ip addr
lxc exec <remote:instance> -- ip route
lxc exec <remote:instance> -- ss -lntup
lxc exec <remote:instance> -- systemctl --failed
lxc exec <remote:instance> -- systemctl status <service>
lxc exec <peer-container> -- curl -v http://<instance-ip>:<port>/
lxc info <remote:instance> --show-log
```

Interpret the first failing boundary:

- No instance or stopped instance: lifecycle/state issue.
- No address or route: profile, NIC, or bridge issue.
- No listening socket: application or service issue.
- Socket works locally but not from a peer container: bind address, container firewall, or bridge issue.
- Reachable on the bridge but not from outside: ingress configuration, DNS, host firewall, or external routing issue.

Do not "fix" a failure by adding interfaces, proxy devices, firewall rules, or
privileged settings without first identifying the failing boundary and obtaining
approval for the proposed mutation.