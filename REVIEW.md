# Review

Review the issue specification and approved plan in three passes: correctness,
security/data exposure, and intent/compatibility. Report actionable findings
with severity, location, evidence, and a proposed correction.

Important findings change behavior, lose data, expose private information, or
breach an explicit contract. Style preferences are nits; report at most three.
Do not repeat inventory/frontmatter failures already enforced by
`make skills-verify`, or review generated bundle assets as authored source.

For SKILL.md, `references/`, `AGENTS.md`, or prompt changes, add an
instruction-prose pass against `AGENTS.md` "Skill authoring": a prohibition
that "do Y" alone would carry, an example the stated principle already
covers, cases standing in for a judgment, and a new directive that names no
failure or contract gap. These are nits unless they change runtime behavior.

For LinkedIn manager changes, also check:

- Verify the bundle with `make skills-verify`.
- Check setup remains idempotent and preserves existing records, unknown dates,
  duplicate links, and unknown frontmatter.
- Confirm public profile reading is limited to one explicitly authorized read;
  blocked access must not create `profile/current.md`.
- Confirm new on-demand ideas receive no inferred dates or reminders, existing
  dated history survives, and missing cadence mode retains weekly compatibility.
- Confirm no owner identity or workspace-specific paths are present in the
  public skill bundle.
- Error messages: a new or changed error, refusal or failure message a person or agent sees names the cause (what failed and why) and the next step (the command, setting or target that fixes it). When secrets, ids or paths must stay out, it names the cause class and how to check it. A message missing either is a finding; Important when it is the only signal of a blocked action (a CLI exit, a refused tool call), otherwise a nit.

Repeated behavioral mistakes belong in `AGENTS.md`. Findings are evidence, not
merge authorization; merge only on user instruction.
