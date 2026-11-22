# Inbox Item Manifest Schema v1

Every normalized inbox item has exactly one `manifest.yaml`.

```yaml
schema: inbox-item/v1
id: YYMMDD-channel-slug
status: pending
channel: arc
provider: local
kind: file
received_at: YYYY-MM-DDTHH:MM:SS+09:00
dedupe_key: sha256:<digest>
source:
  uri: ""
  original_name: ""
  message_id: ""
  thread_id: ""
files:
  - path: raw/original.ext
    role: primary
    mime: application/octet-stream
    sha256: "<digest>"
metadata:
  source_kind: ""
  processing_context: ""
  processing_hints: {}
```

## Required Fields

| Field | Rule |
|---|---|
| `schema` | Must be `inbox-item/v1`. |
| `id` | Stable local ID, usually `YYMMDD-channel-slug`. |
| `status` | `pending`, `done`, `failed`, or `duplicate`. |
| `channel` | Configured `inbox.channels` key. |
| `provider` | `local`, `mso`, `gws`, `telegram`, or another configured provider slug. |
| `kind` | `file`, `message`, `attachment`, `document`, `transcript`, `data`, or `bundle`. |
| `received_at` | Local timestamp with timezone. |
| `dedupe_key` | Provider ID or `sha256:<digest>`. |
| `files` | Array of local files relative to the item directory. |

`channel` is always the root `inbox.channels` key. For source-specific detail,
such as `drop/mso/mail/` or `drop/kakao/files/`, use `metadata.source_kind`
instead of creating fine-grained channel names.

## Processing Hints

`metadata.processing_hints` is a free-form map. It is optional, consumers ignore
keys they do not know, and adding a key is not a schema change.

| Hint | Values | Rule |
|---|---|---|
| `intake_mode` | `auto`, `manual` | How the item was staged. **Absence means `manual`**, and so does any unrecognized value, so nothing a person stages has to set it. Only automated producers write `auto`. |

`auto` marks an item a robot staged (the mail digest today). Those items go
through an unattended propose stage that writes `extracted_file`, `summary_file`
and `route_file` into the item and moves nothing — see `inbox-process` §Proposal-Only
Mode. `manual` items are staged and processed interactively.

Producers may add their own keys next to it (the mail digest also writes
`digest_category`, `digest_reason`, `ai_classified`). `inbox-process` writes
`key=value` tokens from the user's invocation into the same map.

## Dedupe Keys

Prefer source-native identifiers when available:

- email/message: RFC 5322 message ID or provider message ID
- cloud document: drive item ID, file ID, or source URI
- chat message: chat ID plus message ID or export row ID
- channel-root local file: SHA-256 digest of primary file

If a source ID might expose private account details, store it only in the
workspace item manifest, never in this public skill package.

## File Roles

Use `primary` for the main artifact. Use `attachment`, `sidecar`, `metadata`,
`preview`, or `transcript` for supporting files. For a `kind: message` or `kind: bundle` item
that references local files in a channel's configured `drop_paths`, copy each
attachment into the item raw directory and add a `files[]` entry with its
item-relative `path`, `role: attachment`, `mime`, and `sha256`. Stage a drop
file as a standalone item under the root channel only if it is unlinked per
§Drop Residuals and not referenced by a message or bundle item in this run. Set
its `kind` from the matching `source_kinds` subfolder mapping, falling back to
the channel `kind`. Use `attachment` only for attachment subfolders. Skip linked files for standalone staging;
still link referenced attachments into a message or bundle item in this run.

## Drop Residuals

A drop residual is a file under a channel's configured `drop_paths`, searched
recursively and counting files only, that meets all of these:

- It is not a message record, meaning it is not in a subfolder whose
  `source_kinds` maps to `message`. A JSON file at the drop root is also a
  message record when the channel `kind` is `message` or `bundle` and the
  JSON contains a provider message ID.
- It is not OS noise or a placeholder (`.DS_Store`, `.gitkeep`), and it does
  not match the channel's `drop_ignore` globs.
- Its SHA-256 matches no `files[].sha256` in any item manifest under
  `inbox.paths.items`, in any state.

When file hashes cannot be computed in this run, report the residual check as
unavailable, name the missing capability, and do not estimate a count. State
the next step: configure `inbox.hooks.residual_counter` or allow a shell.

The collector owns message records. A copied source can remain in the drop
directory after it is carried.
