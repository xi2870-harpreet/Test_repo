---
id: KI-0008
title: Newest Claude models (Sonnet 5 / 5.5, Opus 5.5) listed in docs but unavailable in sandbox AWS accounts
category: known-issue
products: [tracks1, labs2, cloud]
status: draft
audience: internal
source:
  - type: unthread
    ref: tickets 4275, 4584, 4509 (closed 2026-11-23 to 2026-11-24)
  - type: unthread
    ref: tickets 4433, 4390 (closed 2026-11-03 to 2026-11-04)
last_verified:
verified_by:
owner: Support
tags: [bedrock, aws, claude, models, quota, throttling, gemini, vertex]
---

## Symptom
A customer's workshop or lab calls a newer Claude model on AWS Bedrock (Sonnet 5, Sonnet 5.5, Opus 5.5) from the sandbox and it is refused, although the docs list the model.

## Cause
AWS has not yet raised the required quota and policy for these models in the sandbox accounts. Instruqt had asked AWS and had no timeline. The documentation was updated ahead of availability.

## Workaround
- Use a model that works: Sonnet 4.6 was the latest working option; Haiku 4.5 and Sonnet or Opus 4.6 were available for a demo. One other model (Kimi K3.1) became usable with its inference profile ID.
- Before a workshop, ask for the limits to be raised and run a small concurrent test to check for throttling.

## Related: throttling
Bedrock request-rate limits can throttle many learners at once and may vary by attendee account. Lowering concurrency was suggested as a temporary workaround; no track setting changes it (ticket 4433, closed with no recurrence).

## Gemini / Vertex
Supported Gemini model names are enabled by Support on request and the docs list is updated by hand (ticket 4390).

## Notes
Five tickets, but the availability status is time-sensitive and from Support statements only, so Unverified. Check the current supported-models docs and ask Engineering before promising a model or date. Customer details left out on purpose.
