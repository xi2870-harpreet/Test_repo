---
id: RM-0002
title: Labs 2.0 has no cleanup script on deprovision (cleanup is per task); Tracks supported until 27 Sep 2027
category: roadmap
products: [labs2, tracks1]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4524 (closed 2026-11-16)
last_verified:
verified_by:
owner: Support
tags: [labs2, cleanup, deprovision, migration, tracks-support]
---

## Question
Can a Labs 2.0 lab run a script when it deprovisions, like the Tracks cleanup script when a sandbox stops?

## Answer (as of 2026-11-16)
No. Cleanup scripts in Labs are per task. There is no equivalent yet to the Tracks cleanup script that runs on sandbox stop. A per-task cleanup does not fit cases that must run at the end of the lab, for example deleting ephemeral external accounts created during setup.

Support told the customer Tracks remain supported until 27 September 2027, so they can stay on Tracks. No timeline for a Labs equivalent. The request was passed to the product team as customer insight.

## Notes
One ticket, so Unverified. Check the migration guide (cleanup scripts section) and the launch timeline page before answering; both were cited in the ticket. Do not promise a date. Relevant to the labs2-migrate skill when a track depends on a cleanup script. Customer details left out on purpose.
