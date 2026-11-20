---
id: KI-0002
title: Track pages load very slowly or get stuck (browser localStorage full)
category: known-issue
products: [tracks1]
status: draft
audience: internal
source:
  - type: notion
    ref: https://app.notion.com/p/379fa4cf12ea80df8930f0f378807903 (Known Issues/ Workarounds, last edited 2026-06-08)
last_verified:
verified_by:
owner: Support
tags: [ui, browser, performance]
---

## Symptom
Track pages load very slowly or hang while loading. The user has visited several tracks over time.

## Cause
The browser's localStorage limit is about 5 MB. The platform stores version-control data per track locally. After a user visits many tracks the storage fills up and the UI hangs on load.

## Fix / workaround
1. Open the track in an incognito/private window; this usually works.
2. Clearing localStorage fixes it temporarily.
3. To narrow it down, ask the user for: the affected track URL and which pages were affected, the browser and version, and whether it also happens in an incognito/private window.

## Customer-safe wording
(not yet reviewed; a person must approve any customer-facing wording)

## Notes
Imported from a single Notion page that shows "unverified" and was last edited 2026-06-08, so it may be out of date. A reviewer should check whether the behaviour still occurs and whether it affects Labs 2.0 too, then set `last_verified`, `verified_by` and the status.
