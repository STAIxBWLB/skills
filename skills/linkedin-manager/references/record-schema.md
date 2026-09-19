# Record Schema

Every record is a markdown file with YAML frontmatter. Always write a
human-readable `title`. Preserve keys you do not know. Dates are ISO
(`YYYY-MM-DD`), times ISO with offset in the configured timezone.

## Post (`ideas/`, `drafts/`, `scheduled/`, `published/YYYY/`)

```yaml
---
title: Short human-readable title
type: linkedin-post
status: idea            # idea | draft | scheduled | published | dropped
language: en
pillar: null            # one of linkedin.pillars, or null
topic: one line
why: null               # why it is worth a post; set by `idea`
targetMonth: null       # YYYY-MM; set by `idea`
format: text            # text | image | document | video | poll | article
created: 2026-01-05
scheduledFor: null      # set by `ready`
publishedAt: null       # set by `published`
url: null               # set by `published`
mentions: []            # people and organizations, confirmed by the user
hashtags: []            # mirrors the hashtags in the body; the body is what gets posted
media: []               # file paths or descriptions, each with alt text
source: null            # idea source link or path; for imports, the export file
relatedTask: null       # set only when the task skill reports one
metrics: []             # appended by `metrics`, never rewritten
---

Post text exactly as it will be, or was, published, hashtags included. Every
character count is taken from this text. An idea leaves it empty.

---

Working notes, alternatives, the brief. Not part of the post.
```

A metrics snapshot:

```yaml
metrics:
  - date: 2026-01-12
    impressions: 1840
    reactions: 52
    comments: 7
    reposts: 3
    source: user            # user | export:<file>; written by the skill
```

Rules: `source` is the only field the skill adds on its own. One snapshot per reading, appended in date order; omit a field the
source did not give; extra fields keep the label the user or the export used.
The file moves between lifecycle directories as `status` changes and keeps its
name. `dropped` files stay where they were.

## Imported posts

An imported record uses the post schema with these rules:

- Filename date is the publish date, not the import date.
- `title` is the first line of the text, cut at about 60 characters; `<slug>`
  is derived from it in lowercase ASCII, or `post-N` when nothing usable remains.
- `created` equals the publish date. `language` is detected from the text.
- `format`: `image`, `video` or `document` when the export shows media, `text`
  otherwise; a shared link stays `text` with the link kept in the body or under
  the export's own column label.
- `publishedAt`: LinkedIn exports carry no timezone. Ask the user which
  timezone the export uses; when unanswered,
  write the value as given without an offset and say so. Never assume one.
- `pillar`, `why`, `targetMonth`, `scheduledFor`, `relatedTask` stay null.
- Other export columns are kept under their own labels.

## Plan (`calendar/YYMM-plan.md`)

```yaml
---
title: LinkedIn plan 2026-01
type: linkedin-plan
period: 2026-01
cadence: 1 per week
---
```

Body: a table of slots (`date`, `pillar`, `working title`, `record`, `state`)
followed by the dates and events the plan was built around. `record` is the
path of the idea or draft that fills the slot, or empty.

## Review (`reviews/YYMM-review.md`)

```yaml
---
title: LinkedIn review 2026-01
type: linkedin-review
period: 2026-01
posts: 4
measured: 3
---
```

## Profile (`profile/current.md`, `profile/history/YYMMDD-profile.md`)

```yaml
---
title: LinkedIn profile text
type: linkedin-profile
recordedAt: 2026-01-05
source: pasted by the user
---
```

Body: one `##` section per profile field the user keeps (Headline, About,
Experience entries, Education, Featured, Skills), holding the live text.

## Engagement (`engagement/YYMMDD-<slug>.md`), optional

```yaml
---
title: Reply to a comment on <post title>
type: linkedin-engagement
kind: comment           # comment | message
post: published/2026/260105-post-example.md
date: 2026-01-06
sent: false             # the user sets true after sending by hand
---
```

Body: the incoming text quoted, then the reply as drafted. Store no more about
the other person than the exchange itself.
