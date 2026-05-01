#!/usr/bin/env bash
# STAIxBWLB/skills installer.
# Symlinks individual skills into ~/.claude/skills/ (Claude Code's skills root).

set -euo pipefail

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
TARGET="${HOME}/.claude/skills"

if [[ ! -d "$TARGET" ]]; then
  echo "Creating $TARGET"
  mkdir -p "$TARGET"
fi

echo "Available skills:"
for d in "$SKILLS_DIR"/*/; do
  skill="$(basename "$d")"
  echo "  - $skill"
done

echo
read -rp "Install all? [Y/n] " yn
case "${yn,,}" in
  n|no) echo "Aborted."; exit 0;;
esac

for d in "$SKILLS_DIR"/*/; do
  skill="$(basename "$d")"
  link="$TARGET/$skill"
  if [[ -L "$link" ]]; then
    echo "↻ Re-linking $skill"
    rm "$link"
  elif [[ -e "$link" ]]; then
    echo "✗ $skill already exists at $link (not a symlink) — skipping"
    continue
  fi
  ln -s "$d" "$link"
  echo "✓ Linked $skill → $link"
done

echo
echo "Done. Restart Claude Code to pick up the new skills."
