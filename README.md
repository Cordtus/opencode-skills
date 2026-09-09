# opencode-skills

Shareable, generalized agent skills for [opencode](https://opencode.ai).

## Packages

- `skills/lxc-lxd-operations`: safe LXD/LXC administration for agentic use —
  discovery-first topology mapping, approval gates for destructive/exposing
  actions, and a reverse-proxy-first networking pattern.

## Install

```bash
# opencode
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh)

# claude
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh) ~/.claude/skills

# codex
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh) ~/.codex/skills
```

The package is self-contained; `SKILL.md` provides the contract and
`reference/` holds command and troubleshooting details.

## Contributing

Skills are written generic: use placeholders (`<remote:instance>`,
`<proxy-container>`) instead of real names, and keep layout assumptions as
discoverable defaults rather than fixed facts.