# opencode-skills

Shareable, generalized agent skills for [opencode](https://opencode.ai).

## Packages

- `skills/lxc-lxd-operations`: safe LXD/LXC administration for agentic use —
  discovery-first topology mapping, approval gates for destructive/exposing
  actions, and a reverse-proxy-first networking pattern.

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

- Replace placeholders like `<proxy-container>` with your actual reverse-proxy
  container name (e.g. `caddy`).
- Adjust the networking layout in `reference/networking.md` if your ingress is
  not a reverse-proxy container (e.g. bare host proxy devices, a physical NIC,
  or a non-LXD-managed bridge).
- Adapt the `ufw` escalation examples if your host uses a different firewall
  (`firewalld`, `iptables`, nftables).
- Tighten or loosen the approval gates in `SKILL.md` to match how much agency
  you want the agent to have.

