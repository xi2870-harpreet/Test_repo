---
id: PR-0003
title: Hot start pools: what happens to sandboxes when the pool ends or is deleted
category: platform-rule
products: [tracks1, live-event]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4552 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [hot-start, pool, live-event, sandbox, timeout]
---

## Rule
- **Claimed sandboxes keep running.** Once a learner claims a hot start sandbox it belongs to that learner's play and is no longer part of the pool. Reaching `ends_at`, or deleting the pool, does not terminate it. It runs until the learner stops the track or the track's time limit or idle timeout is reached. No warning is needed and no active session is lost.
- **Unclaimed sandboxes are removed** at `ends_at` (and on deletion). A learner who claims just before `ends_at` keeps the sandbox.
- **After the pool ends,** a learner who starts the track gets a regular, non-hot-start sandbox, with the normal setup time.
- **Deleting a pool by hand** has the same outcome as reaching `ends_at`.
- Claimed sandbox lifetime comes from the track settings (time limit, idle timeout), not the pool.

## When it matters
Planning a live event: set `ends_at` just after the last point learners are expected to join (for example kickoff plus 15 to 30 minutes), set the track time limit at least as long as the session, and make the idle timeout long enough for listen-only parts.

## Customer-safe wording
Draft from the ticket reply, not reviewed; reuse only after a person approves it.

## Notes
One ticket, so Unverified. The answer came from a Support reply; Engineering did not confirm it in the thread. Check against Live Event known-risks and the hot start docs before relying on it. Related: the live-event skill's known-risks file.
