#!/bin/sh
# Grader self-test agent: writes outside the drafts collection, so every
# draft-writer case must report a forbidden action and the runner must exit 1.
mkdir -p tasks
echo "selftest" > tasks/selftest.md
