# Anchor Integration

Anchor manages skills through `~/.anchor/skills` and runtime dependencies through
`~/.anchor/env`.

## Layout

```text
~/.anchor/
  skills/
    registry.json
    sources/
    managed/
    cache/
    installed/
      <installedAs> -> <repo>/skills/<name>
  env/
    .venv/
    node_modules/
    status.json
```

## Source Registration

This public repo is registered as a linked source:

```json
{
  "id": "stai-public",
  "kind": "linked",
  "path": "~/.anchor/skills",
  "skillsSubdir": "skills"
}
```

The private sibling repo uses `stai-private` and owns only private skill
packages. Shared `env/` and `lib/` stay in this public repo.

## Installers

- `./install-anchor.sh -n` previews Anchor-internal entrypoint links under
  `~/.anchor/skills/installed`.
- `./install.sh -n` previews Claude links under `~/.claude/skills`.
- `./install-codex.sh -n` previews Codex links under
  `${CODEX_HOME:-~/.codex}/skills`.

Anchor-created links are two-step links:

```text
~/.claude/skills/<name>          -> <source-repo>/skills/<name>
~/.codex/skills/<name>           -> <source-repo>/skills/<name>
~/.anchor/skills/installed/<name> -> <source-repo>/skills/<name>
```

Existing Claude/Codex links should be adopted by Anchor, not overwritten.

`~/.anchor/skills/registry.json` is owned by Anchor. Repository installers must
not write simplified registry files; they may only create previewable symlinks.

## Runtime Bootstrap

Use the public runtime scaffold to create Anchor's runtime root:

```bash
env/setup.sh --target ~/.anchor/env --dry-run
env/setup.sh --target ~/.anchor/env
```

Do not create `~/.anchor/skills/env`; Anchor reserves `~/.anchor/skills` for
skill catalog state and uses `~/.anchor/env` for runtime dependencies.
