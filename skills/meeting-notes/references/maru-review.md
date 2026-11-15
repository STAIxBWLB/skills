# Maru review-mode output

Progress markers and the review object for a background/review-mode run. The
write and follow-up limits stay in SKILL.md *Maru Run Contract*.

## Phase markers

Prefix major progress logs with stable phase markers so Maru can render
stepwise status:

- `[phase:source]` after source text/files are identified.
- `[phase:normalize]` while applying guides, glossary, people, and naming
  conventions.
- `[phase:verify]` while checking high-risk facts against internal
  sources and web research, and assembling corrections.
- `[phase:draft]` while drafting the meeting note.
- `[phase:proposal]` when preparing the `maru_skill_proposal_v1` block.
- `[phase:review]` when preparing the `maru_meeting_review_v1` block.
- Always include exactly one phase marker per line and keep that marker
  at the start of the line (after the timestamp).
- For errors, prepend `ERROR:` to the message or use `[phase:error]`.

## `maru_meeting_review_v1`

```json
{
  "schemaVersion": "maru_meeting_review_v1",
  "summary": "short review summary",
  "terms": [
    { "label": "source term", "normalized": "workspace term", "note": "why", "required": true }
  ],
  "people": [
    { "label": "source person", "normalized": "canonical person", "note": "role", "required": true }
  ],
  "properNouns": [
    { "label": "source name", "normalized": "canonical name", "note": "context", "required": true }
  ],
  "uncertainties": [
    { "label": "uncertain item", "normalized": "best guess", "note": "needs user check", "required": true }
  ],
  "corrections": [
    {
      "before": "exact passage from source/draft",
      "after": "proposed replacement",
      "category": "transcription|fact|attribution|date|amount|decision|action|omission|supplement",
      "evidence": "internal note path / calendar event / source URL",
      "confidence": "resolved | card_reference | web_unverified | fuzzy",
      "required": true
    }
  ],
  "enrichment": {
    "project": "[[vault-note]]",
    "description": "Outcome or purpose beyond the meeting title",
    "domain": "projects",
    "topics": ["[[projects]]"],
    "entities": ["Canonical person", "Canonical organization"],
    "relatedMeetings": ["[[meeting-note]]"],
    "relatedTasks": ["[[task-note]]"],
    "calendarLink": { "calendarId": "id-or-null", "calendarEventId": "id-or-null" },
    "resolvedPeople": [
      { "surface": "source person", "canonical": "canonical name", "wikiLink": "[[person]]", "confidence": "resolved" }
    ]
  },
  "followups": [
    {
      "skill": "task-management",
      "title": "Create task from action item",
      "prompt": "proposal-only follow-up prompt",
      "reason": "why this is useful",
      "assignee": "person or null",
      "due": "YYYY-MM-DD or null",
      "meetingSourcePath": "meetings/YYYY/YYYY-MM/<file>.md",
      "selected": false
    },
    {
      "skill": "vault-extract",
      "title": "Extract meeting decisions",
      "prompt": "Read the approved meetingSourcePath and re-run vault-extract preconditions. Include the actual vault fields, workspace origins, sibling hint and candidates here, per vault-handoff.md.",
      "reason": "Preserve a source-supported decision",
      "meetingSourcePath": "meetings/YYYY/YYYY-MM/<file>.md",
      "vault": {
        "description": "Outcome or purpose beyond the meeting title",
        "domain": "projects",
        "topics": ["[[projects]]"],
        "entities": ["Canonical person", "Canonical organization"]
      },
      "workspaceOrigins": [
        {"field": "relatedMeetings", "link": "[[meeting-note]]", "path": "meetings/YYYY/YYYY-MM/meeting-note.md"}
      ],
      "siblingMeetingHint": null,
      "candidates": [
        {"title": "Source-supported decision", "type": "decision", "evidence": "Decision passage in the meeting note"}
      ],
      "selected": false
    }
  ]
}
```

The `enrichment` object, the `corrections` array, and the
`assignee`/`due`/`meetingSourcePath` follow-up fields are additive and optional:
populate them only from resolved enrichment (context-enrichment §3/§4) and
verified corrections (workflow step 5), and omit or null them otherwise.
Parsers ignore unknown fields.

During normalize, apply `vault-handoff.md` before populating the vault fields in
`enrichment`. They are reviewable proposals, not proof of a successful vault
write. Keep rejected topic candidates in `uncertainties` with their cause and
remedy, never in `enrichment.topics` or the note's frontmatter. When extraction
is blocked, state why in `summary` and omit its follow-up. For ready extraction
proposals, use `vault-handoff.md` §Extraction proposal for the structured fields
and self-contained prompt. Unknown fields in existing records are preserved.
