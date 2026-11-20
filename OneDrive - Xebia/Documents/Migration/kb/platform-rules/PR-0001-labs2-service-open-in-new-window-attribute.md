---
id: PR-0001
title: Labs 2.0 service tab uses open_in_new_window (not 1.0's new_window)
category: platform-rule
products: [labs2]
status: draft
audience: internal
source:
  - type: notion
    ref: https://app.notion.com/p/3e2fa4cf12ea805eb558f8263d6d13b5 (2.0 Pre launch week - Decision log & Known issues, last edited 2026-09-23)
last_verified:
verified_by:
owner: Support
tags: [labs2, service, config, migration]
---

## Rule
To open a service tab in a new window in Labs 2.0, set `open_in_new_window = true` on the service. The runtime already partly supported this name, the same attribute `external_website` uses, so it was kept instead of 1.0's `new_window` to avoid breaking existing labs. The public docs were updated to match.

## When it matters
- A migrated track still has `new_window` on a service: it will not behave as in 1.0; use `open_in_new_window`.
- A customer asks how to open a service in a new window.

## Notes
From a pre-launch decision log marked "unverified". A reviewer should confirm against the current Labs docs (docs.labs.instruqt.com, Reference) and add the migration step to the labs2-migrate guide if it is missing.
