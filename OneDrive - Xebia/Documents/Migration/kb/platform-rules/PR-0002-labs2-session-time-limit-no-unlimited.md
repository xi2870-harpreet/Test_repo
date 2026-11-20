---
id: PR-0002
title: Labs 2.0 session time: no unlimited option, but Duration can be set very high
category: platform-rule
products: [labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4560 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [labs2, session, timeout, duration, extend, limits]
---

## Rule
There is no "unlimited" total session time. The `Duration` setting accepts any value the author needs, including very large ones such as 500 hours, and Support told a customer there was no issue with that. `Extend` lets a learner add time once during a session.

## When it matters
A customer asks whether learners can have indefinite access to a lab or learning path.

## Customer-safe wording
Draft from the ticket, not reviewed: "Unlimited session time isn't supported, but you can set Duration as high as your learners need, and set Extend so learners can add time once during a session." A person must approve before it is sent.

## Notes
One ticket, so Unverified. Check the public docs (Session Limits, docs.labs.instruqt.com) for any maximum and for how Duration, Extend and idle timeout interact. No upper limit was verified; "any number" was the answer given.
