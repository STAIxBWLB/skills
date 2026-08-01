# maru-skills

OTA skill bundle source for the [Maru](https://github.com/STAIxBWLB/maru) desktop app.

This repository is the single source of truth for the skills the Maru app
ships over the air. Every push to `main` that touches bundle content
publishes a signed, immutable bundle to the rolling
[`skills-channel`](https://github.com/STAIxBWLB/skills/releases/tag/skills-channel)
prerelease; running apps discover it, verify the signature, and update
without an app release.

## Layout (bundle root = repo root)

- `skills/<name>/SKILL.md` — the skills themselves (36)
- `envs/default/` — shared Python/Node runtime scaffold for skills
- `lib/` — shared helpers (e.g. `build-graph.py`)
- `docs/` — reference material used by skills
- `manifest.json` — bundle manifest: `repoSlug`, `channelTag`,
  `minAppVersion`, and the canonical skill list
- `SKILL_INDEX.md` — human-readable index (manifest.json is authoritative)

Repo plumbing (`scripts/`, `.github/`, `Makefile`, `package.json`,
`README.md`, `AGENTS.md`, `LICENSE`) never ships in the bundle.

## Add or change a skill

1. Edit `skills/<name>/SKILL.md`. Frontmatter `name` must equal the
   directory name; `description` is required.
2. A new skill also needs a `manifest.json` entry
   (`{name, path: "skills/<name>", tier, tags}`) and a `SKILL_INDEX.md` line.
3. `make skills-verify` — manifest/directory agreement, frontmatter,
   tracked-inventory rules (NFC filenames, no symlinks, no runtime junk).
4. PR to `main`. Merge triggers the publish workflow; there is nothing
   else to do.

## Release flow

`push to main` → `.github/workflows/release-skills.yml`:
`make skills-verify` → `make skills-package REVISION=<run_id>` → minisign
(`tauri signer sign`, same key as the Maru app updater) → upload
`maru-skills-r<run_id>-<sha>.{zip,zip.sig,json.sig,json}` to the
`skills-channel` prerelease. The metadata JSON uploads last so a partially
uploaded bundle is invisible to clients.

- **Revision** = GitHub `run_id`, globally increasing; clients apply only
  `revision > installed`.
- **Assets are immutable.** Never edit or delete them; publish a new
  revision instead.
- **`minAppVersion`** (`manifest.json`) gates which apps may apply a
  bundle. Bump it only when a bundle genuinely needs newer app code.
- Signing secrets (`TAURI_SIGNING_PRIVATE_KEY`,
  `TAURI_SIGNING_PRIVATE_KEY_PASSWORD`) are repo secrets; the public key is
  embedded in the app's `tauri.conf.json`.

## Client behavior (Maru app)

- Auto check 3 s after launch and every 6 h; auto-applies when the update
  is clean (no env change, builtin not dirty, app ≥ minAppVersion),
  otherwise shows an update-available notification.
- Manual: Settings → System → Skills (Check / Apply), or
  `maru skills update --check|--apply`.
- First-run/offline installs use the app-embedded bootstrap snapshot; the
  OTA bundle supersedes it on first contact.

## History

Split from `STAIxBWLB/maru` `skills/` on 2026-08-01 via
`git subtree split` (full history preserved). The previous occupant of
this repo (a Claude Code skills catalog) is archived on the
`archive/legacy-catalog` branch.
