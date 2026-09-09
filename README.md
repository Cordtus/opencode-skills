# opencode-skills

Shareable, generalized agent skills for [opencode](https://opencode.ai).

## Packages

- `skills/lxc-lxd-operations`: safe LXD/LXC administration for agentic use —
  discovery-first topology mapping, approval gates for destructive/exposing
  actions, and a reverse-proxy-first networking pattern.

## Install

One line, no clone required:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh)
```

Installs all packages into `~/.config/opencode/skills/`. To install to a custom
location instead, pass it as an argument:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Cordtus/opencode-skills/main/install.sh) /path/to/skills
```

Or, to install from a clone, copy the package directory directly:

```bash
cp -r skills/lxc-lxd-operations ~/.config/opencode/skills/
```

The package is self-contained; `SKILL.md` provides the contract and
`reference/` holds command and troubleshooting details.

## Contributing

Skills are written generic: use placeholders (`<remote:instance>`,
`<proxy-container>`) instead of real names, and keep layout assumptions as
discoverable defaults rather than fixed facts.