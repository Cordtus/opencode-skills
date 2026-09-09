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

The skill ships generalized: it discovers the real layout before acting and
only assumes safe defaults. For most setups it works as-is. If you want it
tuned to your environment, just ask your agent to do it — paste this into your
agent:

```text
Read the lxc-lxd-operations skill (SKILL.md and reference/) I just installed,
then fine-tune it to my actual environment. Discover my real LXD layout first
(lxc remote get-default, lxc list, lxc profile show default, lxc network list,
lxc storage list). Update the skill so fixed facts about my setup — common
container names, bridge/subnet details, how I expose services (reverse proxy
container name, proxy devices, host firewall), and my approval preferences —
are stated instead of rediscovered, without losing the discovery-first safety
behavior. Report what you changed.
```

What the agent might adjust:

- Fixed facts (common container names, bridge subnets, ingress path) so they do
  not have to be rediscovered every run.
- The networking guidance in `reference/networking.md` to match how this host
  actually exposes services.
- The `ufw` escalation examples if the host uses a different firewall
  (`firewalld`, `iptables`, nftables).
- The approval gates in `SKILL.md` to match how much agency you want the agent
  to have.

