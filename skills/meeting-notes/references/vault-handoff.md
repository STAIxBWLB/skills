# Vault handoff

The `vault-extract` and `vault-connect` skills are installed by `vmem setup <host> --apply`.

Read during workflow step 4 (`[phase:normalize]`) before drafting vault fields,
and again when preparing an extraction follow-up.

## Vault fields

Before vault lookup, read `lib/vault_adapter.md` §Runtime Discovery and bind
its vault id. Use the bound vault on every vmem call.

- `description`: one sentence, 10-200 characters, different from the title and
  adding information about the meeting's outcome or purpose.
- `domain`: one of `research`, `projects`, `teaching`, `operations`, `people`,
  `ai-practice`. Read the resolved registry `vault_note` with `vmem_read` for
  its domain and MOC topics; without a resolved project, use the meeting's
  subject to propose a domain and verify a matching domain MOC.
- `topics`: a non-empty array of quoted `[[MOC]]` links. Confirm every target
  against `vmem_mocs`, following pagination when returned. A registry
  `vault_note` itself is eligible only when the MOC lookup lists it; otherwise
  use its validated MOC topics or a relevant existing domain MOC. Keep ordinary
  project/decision notes in `project` or body links, separate from topics.
- `entities`: canonical names of resolved people and organizations, including
  those mentioned but absent. These are link-discovery seeds, not guessed
  wiki-links. Keep unresolved names in review uncertainties.

An unavailable lookup, invalid candidate, or missing MOC becomes a review
uncertainty naming the rejected value, cause, and next step (choose an existing
MOC or resolve the lookup). Never invent or auto-create a MOC. Exclude invalid
candidates from the note. When no validated topic or domain remains, keep the
meeting draft reviewable with `topics: []` or `domain: null`, mark extraction
blocked in the review summary, and omit the extraction follow-up until resolved.
A draft with these unresolved fields is not extraction-ready. With enrichment
on and resolved vault access, fill the required fields before proposing filing;
validate them again after user edits before extraction.

## Link namespaces

- `project`: a resolved vault `[[note]]` from the registry, which may be an
  ordinary project or decision note. It does not imply membership in `topics`.
- `attendees`: vault wiki-links only for resolved vault people; otherwise plain
  names. Resolution against a workspace guide alone does not prove a vault link.
- `relatedMeetings` and `relatedTasks`: workspace links resolved to actual files
  under the configured meeting/task roots. Record their workspace-relative file
  paths in the extraction proposal; these stems are not vault identities.
- `source_doc` and `meetingSourcePath`: workspace-relative source file paths.

For vault output, preserve workspace origins as plain paths in `source` or
Relevant Notes. Convert workspace wiki-links in frontmatter and body to resolved
plain paths before building the prospective vault note, even if a vault note
happens to share the stem. If the workspace target cannot be found, preserve
its label as plain text and report the unresolved origin. A vault wiki-link is
retained only after verifying the target in the bound vault; validate the full
prospective note with `vmem_check` before any vault write.

## Extraction proposal

Prepare only when requested and the vault fields are ready. Carry:

- `meetingSourcePath`: the final canonical workspace-relative meeting note path.
- `vault`: the draft's `description`, `domain`, validated `topics`, and `entities`.
- `workspaceOrigins`: objects with `field`, original `link`, and resolved `path`
  for related meeting/task links, so the extractor can preserve their namespace.
- `siblingMeetingHint`: candidate meeting paths, date, resolved project, and
  relationship evidence from the context bundle; use null when none is known.
  This is a hint, not a merge instruction. Apply `vault-extract` §Sibling
  Meeting Merge Rule against the actual sources.
- `candidates`: proposed notes with `title`, `type` (`decision` for an actual
  decision, otherwise `observation`), and source-supported `evidence`.

Include these values in the follow-up `prompt` as well as additive structured
fields, because a host may dispatch only the prompt. Tell the extractor to read
back the approved, filed note, re-run its preconditions, and use that source
rather than stale review values. Proposals grant no permission to run a
follow-up or write to the vault.
