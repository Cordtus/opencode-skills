# opencode-skills

Shareable, generalized agent skills for [opencode](https://opencode.ai).

## Packages

- `skills/lxc-lxd-operations`: safe LXD/LXC administration for agentic use —
  discovery-first topology mapping, approval gates for destructive/exposing
  actions, and a reverse-proxy-first networking pattern.

## Install

Copy a package directory into the opencode skills location:

```bash
cp -r skills/lxc-lxd-operations ~/.config/opencode/skills/
```

The package is self-contained; `SKILL.md` provides the contract and
`reference/` holds command and troubleshooting details.

## Contributing

Skills are written generic: use placeholders (`<remote:instance>`,
`<proxy-container>`) instead of real names, and keep layout assumptions as
discoverable defaults rather than fixed facts.