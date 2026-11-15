SKILL.md is the instruction source for this skill. This file is background for maintainers; it holds no directives.

# Meeting Notes background

## Frontmatter title

The note carries a human-readable `title` so the display name does not depend
on the filename alone. Maru resolves the shown label as
`title -> name -> filename`.

## Structured action items

Action items are written as `{assignee, task, due}` rather than bare checkboxes
so they can seed pre-filled task candidates for `task-management`.

## Review-mode markers and fields

Phase markers sit at the start of each log line so the run-card parser and the
Activity panel can colour-code each phase reliably; `ERROR:` and
`[phase:error]` let the UI surface errors in red. The `enrichment`,
`corrections` and follow-up `assignee`/`due`/`meetingSourcePath` fields were
added later as optional fields; because parsers ignore unknown fields, existing
`maru_meeting_review_v1` consumers are unaffected.

## File layout

Material needed only in one mode lives in `references/`: the verification
procedure (`verification.md`, used when the verification hook is set) and the
review-mode output (`maru-review.md`).

## Change history

- 2026-11-15: Issue #150 aligned meeting frontmatter and extraction handoffs.
  The template lacked extraction-required fields, registry project notes were
  mistaken for MOC topics, and workspace links could be treated as vault links.
  The updated contract separates those namespaces and exposes unresolved
  metadata during review before an extraction proposal is offered.
