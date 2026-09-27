# AGENTS.md

Guidance for AI agents working in this repository.

- This repo is the OTA skill bundle source for the Maru app
  (`STAIxBWLB/maru`). The repo root is the bundle root.
- **Bundle content**: `skills/`, `envs/`, `lib/`, `docs/`,
  `manifest.json`, `SKILL_INDEX.md`. Everything else is repo plumbing and
  must never be referenced from bundle content.
- `manifest.json` is the source of truth for the skill list; keep
  `SKILL_INDEX.md` in sync by hand.
- Skill rules: frontmatter `name` == directory name, `description`
  required, filenames NFC-normalized, no symlinks, no runtime junk
  (`__pycache__`, `.DS_Store`, `.venv`, ...). `make skills-verify` enforces
  all of it — run it before every PR.
- Skills here are prompts and references for AI runtimes, not app code.
  Do not add executables that assume a specific machine; portable
  Python/Node helpers go in `lib/` or `envs/default/`.
- Releases are automatic on push to `main` (see README.md). Never hand-edit
  the `skills-channel` prerelease or its assets.
- `minAppVersion` in `manifest.json` changes only when a bundle needs newer
  app code, and is coordinated with a Maru app release.
- Commit messages: Conventional Commits, English (e.g.
  `feat(skills): add draft-writer`).
- Skills that write records preserve unknown record fields.
- Runtime installations are derived copies: implement changes in this source
  repo through the issue, branch, and PR workflow.

## Skill authoring

Applies to SKILL.md, `references/`, and any text a runtime reads as
instructions.

- **`description` routes; the body instructs.** State the situation the skill
  fits, then what it does (`<situation>: <action>` or `Use when <situation>.
  <action>`), judged for routing clarity within a length budget. The
  normative contract lives in the body. Frontmatter holds only `name`,
  `description`, and fields a host documents (such as `license`); the
  `trigger:` key in `vault-*` skills is legacy, left in place and not copied.
- **Principle before examples.** State the rule, then at most one minimal
  example. Enumerated cases read as the whole answer space; add more only
  when an example fixes an output format or a high-failure behavior.
- **Positive phrasing.** For each "do not X", check whether "do Y" alone
  keeps the force and the boundary. Keep the prohibition when it marks a
  safety, permission, contract, legacy-input, or fallback boundary.
- **Judgment over case chains.** When each rule patches a problem the
  previous one created, remove the step that tried to compute what should be
  a judgment, and state the judgment.
- **Earn each directive.** A new directive names the observed failure or
  contract gap it answers. When editing a skill body, look for lines to
  remove before adding.
- **Split by timing.** Move content to `references/` by when it is needed,
  not by length; the pointer names the moment ("Read `references/x.md`
  before ...").
- **Delivery.** A rule binds only on a surface the runtime reads at the
  moment it applies; host-specific loading still needs a host-neutral
  pointer. Confirm by asking a fresh session to reproduce the rule.
- **Counts and inventories** appear only where a check re-runs them.
- **Public-safe.** Shipped files carry no workspace paths, personal emails or
  domains, or secrets; identity and machine-specific paths live in workspace
  configuration. `make skills-verify` warns on known patterns
  (`PRIVATE_REFERENCE_RULES` in `scripts/skills-bundle.mjs`); add no new hits.

## Verification

Run `make skills-verify` from the repository root. A successful run prints
`skills-verify ok: <N> skills, <M> tracked files` and exits zero;
private-reference warnings print to stderr and do not change the exit code.
Review LinkedIn setup changes against `REVIEW.md`, especially evidence
boundaries, idempotent writes, and on-demand cadence behavior.

## Common pitfalls

- A source filename date is not a publication date.
- A public URL is not evidence of the owner's action.
- A profile proposal is not a live snapshot.
- Preserve explicit user decisions instead of asking for them again.
