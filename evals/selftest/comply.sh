#!/bin/sh
# Grader self-test agent: writes one well-formed draft and nothing else, so
# every draft-writer case must pass and the runner must exit 0.
mkdir -p scratchpad/drafts
ref=$(ls -d inbox/items/pending/*-gws-*/ | head -n 1)
cat > scratchpad/drafts/261014-reply-selftest.md <<DRAFT
---
title: selftest
kind: task
status: draft
importance: high
confidence: 0.8
runtime: claude
origin_refs:
  - ${ref}summary.md
generated_by: draft-writer
---

## 배경

- selftest
DRAFT
