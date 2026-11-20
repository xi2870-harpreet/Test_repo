---
id: KI-0001
title: Lab fails to start when a cloud account is referenced (no cty.Type for cloud.ServiceLimits)
category: known-issue
products: [labs2, cloud]
status: draft
audience: internal
source:
  - type: file
    ref: .claude/skills/labs2-migrate/LEARNINGS.md (section "BLOCKER: any reference to an aws_account / google_project resource")
last_verified:
verified_by:
owner: Support
tags: [cloud-account, aws, migration]
---

## Symptom
`instruqt lab validate` and import are clean, but Play fails with "Lab failed to start": `unable to convert reference resource.aws_account.lab to context variable: no cty.Type for cloud.ServiceLimits (no hcl field tags)`. Hits every reference to the account (container environment values, credentials tab target). Occurs without any `service_limits` block.

## Cause
Platform bug, reproduced by Support on 2026-10-29 and escalated to engineering.

## Fix / workaround
1. Reported fixed on the platform by 2026-10-31 (a reviewer must re-confirm). No change needed in the lab.
2. validate still passes configs that fail at Play, so always play-test cloud-account labs.

## Notes
Example seed entry created from the migration learnings. `last_verified` and `verified_by` are empty: a reviewer must confirm against current platform behaviour before the status is changed from draft to fixed. Related: see the labs2-migrate LEARNINGS for the other cloud-account start failures (user names vs indexes, virtual_browser in a module, cloud_credentials target).
