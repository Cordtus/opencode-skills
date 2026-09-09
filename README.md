# opencode-skills

Shareable, generalized agent skills for [opencode](https://opencode.ai).

## Packages

- `skills/lxc-lxd-operations`: safe LXD/LXC administration for agentic use —
  discovery-first topology mapping, approval gates for destructive/exposing
  actions, and general networking guidance.

## Install

**opencode**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh)
```

**claude**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh) ~/.claude/skills
```

**codex**

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh) ~/.codex/skills
```

## Customizing

The skill ships generalized. Before relying on it, it pays to adapt it to your
own environment:

- `SKILL.md` is the contract — the operating assumptions, approval gates, and
  workflow the agent follows.
- `reference/` holds the command matrix, network/exposure layout, and
  troubleshooting sequence.

To tune it for your setup:

- Fill in any fixed facts you know (common container names, bridge subnets,
  ingress path) so the agent does not have to rediscover them every time.
- Adjust the networking guidance in `reference/networking.md` if your ingress is
  a reverse proxy, bare host proxy devices, a physical NIC, or otherwise differs.
- Adapt the `ufw` escalation examples if your host uses a different firewall
  (`firewalld`, `iptables`, nftables).
- Tighten or loosen the approval gates in `SKILL.md` to match how much agency
  you want the agent to have.

