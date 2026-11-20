---
id: PR-0008
title: Labs 2.0 page access depends on team role (and roles are per team)
category: platform-rule
products: [labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4531 (closed 2026-11-16)
last_verified:
verified_by:
owner: Support
tags: [labs2, roles, permissions, access, teams]
---

## Rule
The Labs 2.0 page is not limited to Owners. Access depends on the team role:
- **Owner and Content Creator:** see and work with every lab in the team (create, import, edit, publish).
- **Instructor:** sees only labs an Owner has shared with them, read-only; can play labs and follow sessions.
- **Member:** no lab access; can view lab reporting and logs only.

## Gotcha
Roles are set per team. A user can be Owner on one team and Member on another, so the Labs 2.0 entry may look disabled on one team only. In the ticket the customer changed the role on the wrong teams (dev and stage) while the affected user was a Member on the main team.

## Triage
Ask which team the screenshot is from and check the user's role there. Content Creator is the usual fix when someone needs to view, create and edit labs without managing team settings.

## Notes
One ticket, so Unverified. The role list came from a Support reply citing the public Roles and permissions page; check it for changes. Personal details and team names left out on purpose.
