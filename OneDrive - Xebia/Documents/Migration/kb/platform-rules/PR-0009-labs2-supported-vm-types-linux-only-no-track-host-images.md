---
id: PR-0009
title: Labs 2.0 VM limits: Linux only, no Track host images, no Windows, no sole-tenant, no OVA/ISO upload
category: platform-rule
products: [labs2, tracks1]
status: draft
audience: internal
source:
  - type: unthread
    ref: tickets 4598, 4346, 3884, 4427 (closed 2026-11-05 to 2026-11-24)
last_verified:
verified_by:
owner: Support
tags: [labs2, vm, windows, host-image, sole-tenant, ova, iso, migration]
---

## Rule (as of late Nov 2026)
- **Linux VMs only.** Windows VMs are not supported in Labs 2.0. Windows support is on the roadmap with no timeline.
- **Track host images cannot be used** in Labs 2.0. Use a Linux preset or import a Linux image.
- **Sole-tenant nodes** are not supported (needed for some Windows Desktop OS licensing). The request was logged as a customer insight, no timeline.
- **OVA and ISO files cannot be uploaded directly** (Tracks). Use a GCP Compute Engine disk image, or build a custom image with Host Images with the Google guest environment installed.

## What to tell the customer's author
A course mixing Linux desktop, Windows Server and OpenShift should stay on Tracks (Instruqt 1.0) for now. Windows client licensing applies, and Windows 11 needs an Azure host with RDP.

## When it matters
Triage of "image import fails" or "cannot find private host image" in Labs 2.0, and planning a Tracks-to-Labs migration (see labs2-migrate).

## Notes
Four tickets, all Support statements, so Unverified. The Windows status is time-sensitive, so check Linear and the docs before answering. Related: KI-0004 (preset VM 401). Customer details left out on purpose.
