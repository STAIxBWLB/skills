---
title: {title}
date: {date}
type: meeting
meeting_kind: "{meeting_kind}"
description: "{description}"
domain: {domain}
topics: []            # populate with validated, existing vault MOC links
entities: []          # resolved canonical people/org names, including non-attendees
topic: {topic}
tags: []
attendees: []          # resolved [[person]] links when enrichment is on
project:               # resolved vault note; need not be a MOC
relatedMeetings: []    # workspace meeting links, not vault targets
relatedTasks: []       # workspace task links, not vault targets
source_doc:            # origin path (transcript / inbox item)
---
# {title}

## Meeting Info

- Date and time: {datetime}
- Venue: {venue}
- Participants: {participants}

## Purpose

- {purpose}

## Discussion

### {topic}

- {point}

## Decisions

- {decision}

## Actions

- [ ] {action} — assignee: {assignee}, due: {due}
