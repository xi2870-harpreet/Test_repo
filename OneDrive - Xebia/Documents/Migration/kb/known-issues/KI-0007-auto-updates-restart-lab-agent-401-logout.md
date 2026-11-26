---
id: KI-0007
title: Automatic OS updates restart the lab agent: session logs out with 401 or terminals drop
category: known-issue
products: [tracks1, labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4473 (closed 2026-11-10)
  - type: unthread
    ref: ticket 4498 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [auto-update, agent, 401, disconnect, ubuntu, terminal]
---

## Symptom
A lab session logs the learner out and returns a 401 error, or terminals and connections drop shortly after the session starts, even though the browser and the VM look fine.

## Cause
Automatic updates on the host restarted the lab agent, which dropped the connection.

## Fix / workaround
- Disable automatic updates for new sessions (Support did this on the customer's behalf in one ticket; for custom images, disable unattended upgrades in the image or setup script).
- For an affected session: stop it and start a new one.

## Notes
Two tickets, both closed with the customer reporting it resolved, but the cause is Support's finding, so Unverified. 4498 is recorded as a platform bug that Engineering fixed; confirm whether the issue still occurs before advising a customer to change their image. Not the same as KI-0006 (firewall blocking the agent ports). Customer details left out on purpose.
