---
id: KI-0005
title: GCP capacity shortage (us-central1) causes slow or failed starts and stuck resumes
category: known-issue
products: [tracks1, labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: tickets 4254, 4455, 4460 (closed 2026-11-04 to 2026-11-11)
  - type: unthread
    ref: tickets 4490, 4456 (closed 2026-11-10 to 2026-11-11)
last_verified:
verified_by:
owner: Support
tags: [capacity, gcp, us-central1, startup, resume, labs2, region]
---

## Symptom
Sessions start slowly, sit in a queued or provisioning state, or fail to start. Typical reports: a track boot stalls during provisioning, a lab with a GCP resource fails on `n1-highcpu-2` across several us-central1 zones, labs start slowly at peak hours, or a paused lab will not resume and stays stuck.

## Cause
A temporary Google Cloud capacity shortage in us-central1 (the cloud could not provide VMs). Automatic retries could not always start the session. In Labs 2.0 the host region cannot currently be selected, so a customer cannot move away from the affected region.

## Fix / workaround
- Tell the learner to retry later; it may work on a later attempt. Starting the lab fresh also works for a stuck resume.
- Check the status page, which Engineering updated during these incidents.
- For Engineering: the reported mitigations were a larger node pool buffer, extra node types added by hand, and work with Google on more reliably available types.
- Resume handling was fixed: a failed resume now returns the lab to the paused state so the learner can try again.

## Notes
Five or six tickets in two weeks, but each recorded only a Support or Engineering statement, so Unverified. Time-boxed: capacity may have recovered, so check the status page and logs before attributing a new report to it. Related: platform-rule PR-0004 (shared regional resources). Customer details and lab names left out on purpose.
