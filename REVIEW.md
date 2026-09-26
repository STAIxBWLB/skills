# Review

Review the issue specification and approved plan in three passes: correctness,
security/data exposure, and intent/compatibility. Report actionable findings
with severity, location, evidence, and a proposed correction.

Important findings change behavior, lose data, expose private information, or
breach an explicit contract. Style preferences are nits; report at most three.
Do not repeat inventory/frontmatter failures already enforced by
`make skills-verify`, or review generated bundle assets as authored source.

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

Repeated behavioral mistakes belong in `AGENTS.md`. Findings are evidence, not
merge authorization; merge only on user instruction.
