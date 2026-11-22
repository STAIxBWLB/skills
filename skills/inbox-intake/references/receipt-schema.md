# Inbox Receipt Schema

Append each receipt as one JSON object on its own line in `_state/index.jsonl`.
Use `schema: "inbox-receipt/v1"` and include these keys on every receipt:

- `schema`, `run_id`, `ts`, `event`, `item_id`, `channel`, `provider`, `kind`,
  `status`, `dedupe_key`, `source`, `dest`

`ts` is an ISO-8601 timestamp with a timezone offset. The canonical `event`
values are `intake`, `process`, `route`, `reject`, `close`, `duplicate`, and
`correction`.

For a correction, set `event` to `correction`, use `kind` to describe the
correction (for example, `reroute`), and include `supersedes` identifying the
previous receipt's `run_id` or `item_id`, plus a `note` explaining the change.

## Check existing receipts

Run this against a JSONL receipt file to print the line number and values for
rows with a missing `schema` key or a non-canonical event. This is a diagnostic;
it does not change the file or validate the rest of the schema.

```sh
jq -c '.event as $event | select((has("schema") | not) or (["intake", "process", "route", "reject", "close", "duplicate", "correction"] | index($event)) == null) | {line: input_line_number, schema, event}' _state/index.jsonl
```
