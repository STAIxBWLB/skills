---
name: prose-only
description: Fixture. Host syntax in prose and bare paths only; expect no host-compat warning.
license: MIT
allowed-tools: Read
trigger: legacy key kept in place
metadata:
  version: "1.0"
---

Claude Code reads session logs from `~/.claude/projects/`, and a host may
install this skill under `~/.claude/skills/` or `~/.agents/skills/` as a
symlink. Hosts that support `$ARGUMENTS` or `${CLAUDE_SKILL_DIR}` expand them;
this skill does not rely on either.

```sh
python3 scripts/run.py --input "$1"
```
