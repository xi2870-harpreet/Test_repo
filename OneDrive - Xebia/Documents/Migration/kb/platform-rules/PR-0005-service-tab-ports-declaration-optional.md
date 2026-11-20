---
id: PR-0005
title: Tracks service tabs: declaring container ports is optional (proxy doesn't check)
category: platform-rule
products: [tracks1]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4489 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [tracks1, service-tab, ports, proxy, allow_external_ingress]
---

## Rule
Declaring a port on the container is **optional for service tabs**. The web proxy sends tab traffic to the host name and port in the tab URL and does not check it against the ports declared on the container. Declaring ports does not open access, change who can reach the service, or affect routing.

## What is not affected
- A service is reachable only by the learner who owns the sandbox (a second browser without the session cannot open it).
- External access is a separate setting: `allow_external_ingress` on a VM. That makes the port public with no login, so prefer a service tab where possible.

## Tips
Bind the app to `0.0.0.0`, not `localhost`. Ports ending in 443 default to HTTPS; the tab can set the protocol.

## Superseded advice
Earlier in the ticket a Support reply said the port also had to be exposed in the container's host settings. Engineering corrected this: it is wrong for service tabs. The public docs (challenge tabs page) were updated afterwards to say declaring is optional.

## Notes
One ticket, but the answer came from Engineering after reading the code, and the docs now agree. Still Unverified until a reviewer checks the current docs page. Customer details left out on purpose.
