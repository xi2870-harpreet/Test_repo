---
id: KI-0004
title: Labs 2.0 preset VM fails to start with 401 "authentication failed" (credentials set in image settings)
category: known-issue
products: [labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4561 (closed 2026-11-18)
last_verified:
verified_by:
owner: Support
tags: [labs2, vm, image, preset, registry]
---

## Symptom
A lab with a VM built from a preset image (for example `centos:8`, Rocky 9) fails to start. The error reads like: `Failed to create resource resource.vm.<name>: build config: resolve version chain for "<image>": fetch version manifest "...docker.pkg.dev/.../<image>": ... response status code 401: unauthorized: authentication failed`.

## Cause
A username and password had been entered in the VM's image settings. Preset images do not need credentials, and the registry rejected them with a 401.

## Fix / workaround
1. Open the VM's image settings and clear the username and password fields (preset images need none).
2. Click Play again to confirm the VM starts.
3. A running VM still shows nothing to learners without a Terminal tab pointing at it: add one under Tabs and place it with Layouts. Without a tab the lab opens to an empty screen even though the VM is running.

## Notes
One ticket, so Unverified. The customer cleared the fields and confirmed it worked. Unclear how the credentials ended up in the settings (for example an earlier custom image, or autofill); ask when it recurs. Customer details, the lab name and ids were left out on purpose.
