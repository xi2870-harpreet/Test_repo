---
id: PR-0006
title: Kiosk mode link token is a shared public access link, not a private secret
category: platform-rule
products: [tracks1]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4497 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [tracks1, kiosk, token, security, access, graphql]
---

## Rule
The token in a Kiosk Mode link is part of a shared access link for the track. Anyone holding the full link can start the track without signing in. It works as a public access link, not a private credential.

## When it matters
A customer's security scanner flags the token as sensitive, or they ask whether it is a secret.

## Guidance
- Share the link only where anyone using it is acceptable.
- Set track limits to cap usage.
- For per-person access, one-time play tokens are available through the GraphQL API. A one-time token can carry user details, so include only what is needed, and try dummy details first.

## Customer-safe wording
Draft from the ticket reply, not reviewed; a person must approve before it is sent.

## Notes
One ticket, so Unverified. No Engineering confirmation in the thread. Check the Kiosk docs before relying on it.
