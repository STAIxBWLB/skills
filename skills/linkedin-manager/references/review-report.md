# Review Report

`review` reports on a period from recorded posts and their snapshots only.

## Selection

- Posts with `status: published` and `publishedAt` inside the period.
- For each post use its **latest** snapshot. Give the snapshot's date and its
  age in days since posting: readings taken at different ages are not
  comparable, and the report says so where ages differ by more than a week.
- A post with no snapshot is **unmeasured**. It appears in the table with empty
  metric cells and `unmeasured` in the snapshot-age column, and is excluded from
  every total and average. It is never zero. A single missing field in a
  snapshot stays empty and is left out of that field's sum, with its own `n`.

## Arithmetic the report may do

- Counts: posts published, posts measured, posts per pillar, per format, per
  language.
- Sums and means over measured posts, per field, with `n` stated.
- Engagement rate only when the user asks or has used it before, defined
  exactly as `(reactions + comments + reposts) / impressions`, per post, and
  only for posts that have all four numbers.
- Ranking of the user's own posts within the period, and comparison with the
  previous period's review when that file exists.
- Show the inputs next to every derived figure so the user can check it.

## What the report may not do

- Cite an outside benchmark, an industry average, or a platform "rule".
- Explain a result causally from one or two posts. With fewer than about eight
  measured posts, describe and do not generalize; say the sample is small.
- Estimate, interpolate or round away a missing value.
- Report on followers, profile views or search appearances unless the user
  supplied those numbers for the period.

## Format

```markdown
# LinkedIn review <period>

## Summary
<three to five lines: what was posted, what was measured, the clearest
difference among the user's own posts, stated with its n>

## Posts
| Date | Title | Pillar | Format | Impressions | Reactions | Comments | Reposts | Snapshot age |

## By pillar and format
<counts and means with n; omit a grouping that has one member>

## Plan versus actual
<slots planned, published, dropped, still open, from the period's plan file>

## Carry forward
<open ideas and drafts, and questions for the user; no targets unless asked>
```
