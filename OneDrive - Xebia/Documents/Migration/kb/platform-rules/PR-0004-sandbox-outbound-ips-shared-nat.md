---
id: PR-0004
title: Sandboxes share outbound public IPs (regional NAT), so source IP can't identify a learner
category: platform-rule
products: [tracks1, labs2, cloud]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4546 (closed 2026-11-17)
last_verified:
verified_by:
owner: Support
tags: [network, nat, ip, sandbox, rate-limit, security]
---

## Rule
Sandboxes do not get distinct public source IPs. Outbound traffic leaves through shared NAT, and sandboxes in the same region share a pool of public IPs. With many concurrent learners, many will reach an external API from the same address. Instruqt does not publish a static IP range for this traffic; the addresses come from Google Cloud ranges that change over time.

## When it matters
A customer's external service rate-limits or blocks by source IP (for example a cooldown after repeated invalid access codes). A per-IP rule is likely to lock out learners who did nothing wrong, for example in a workshop of around 200 concurrent sandboxes.

## Recommended guidance
Key limits on something the customer controls and issues per learner, such as a one-time access code or token injected by the track setup per participant. Use source IP only as a coarse, much higher global ceiling.

## Open items
The ticket says Engineering was asked how many sandboxes typically share one address, whether the address can change during a session, and whether a sandbox's identity can be verified (for example with a signed token). The customer closed the ticket before an answer was recorded, so these are unanswered.

## Notes
One ticket, so Unverified, and the thread recorded no Engineering confirmation. A reviewer should confirm with Engineering, then add the answers to the open items. Customer and organisation names were left out on purpose.
