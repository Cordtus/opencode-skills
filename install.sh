#!/bin/sh
set -e
BASE="https://raw.githubusercontent.com/Cordtus/opencode-skills/main/skills/lxc-lxd-operations"
DEST="${1:-$HOME/.config/opencode/skills/lxc-lxd-operations}"
mkdir -p "$DEST/reference"
curl -fsSL -o "$DEST/SKILL.md" "$BASE/SKILL.md"
curl -fsSL -o "$DEST/reference/commands.md" "$BASE/reference/commands.md"
curl -fsSL -o "$DEST/reference/networking.md" "$BASE/reference/networking.md"
curl -fsSL -o "$DEST/reference/troubleshooting.md" "$BASE/reference/troubleshooting.md"
echo "installed to $DEST"