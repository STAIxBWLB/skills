# Workspace Config

The skill discovers `workspace.config.yaml` by walking up from the current
directory. This public package never stores a real owner name, handle, URL or
path.

## Expected Shape

```yaml
linkedin:
  root: ~/workspace/PATH/TO/linkedin
  timezone: Region/City
  profile_url: https://www.linkedin.com/in/HANDLE
  languages: [en]
  cadence:
    posts_per_week: 1
    preferred_days: [Tue, Thu]
  pillars: [PILLAR_ONE, PILLAR_TWO]
  cv_source: PATH/TO/cv.yml
  public_contact: CONTACT_FOR_GENERATED_TEXT
  skills:
    writer: WRITER_SKILL_NAME
    polish: POLISH_SKILL_NAME
    tasks: TASK_SKILL_NAME
    spreadsheet: SPREADSHEET_SKILL_NAME
  naming:
    post: "YYMMDD-post-<slug>.md"
  paths:
    ideas: ideas
    drafts: drafts
    scheduled: scheduled
    published: published
    calendar: calendar
    reviews: reviews
    profile: profile
    engagement: engagement
```

## Split Section Files

A workspace with a boot-size budget may keep this section in its own file and
leave a pointer comment in `workspace.config.yaml`:

```yaml
# linkedin: -> _meta/config/linkedin.yaml
```

Follow the pointer relative to the directory of `workspace.config.yaml`. The
file's top-level key is still `linkedin`. When both exist, the main config wins.

## Runtime Rules

- Expand `~` before using paths. Relative `cv_source` resolves from the
  directory of `workspace.config.yaml`.
- Every key except `root` is optional. A missing `cadence` means the plan asks
  the user for one; missing `pillars` means posts carry no pillar; a missing
  `skills.*` entry means that handoff is not offered.
- `naming.post` tokens: `YYMMDD` is the creation date for ideas and drafts and
  is kept when the file moves; `<slug>` is lowercase ASCII with hyphens. When the
  workspace has its own naming rule, the configured pattern carries it.
- `cv_source` is read-only to this skill.
- A skill named under `skills` is handed off to only when it is installed. Say
  so when it is not, and continue without it.
