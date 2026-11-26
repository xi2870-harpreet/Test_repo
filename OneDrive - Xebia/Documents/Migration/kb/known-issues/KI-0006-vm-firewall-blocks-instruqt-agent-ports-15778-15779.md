---
id: KI-0006
title: VM firewall blocks the Instruqt agent (TCP 15778/15779): terminal dies, setup or grading fails
category: known-issue
products: [tracks1, labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: tickets 4366, 4368, 4410 (closed 2026-11-02 to 2026-11-11)
last_verified:
verified_by:
owner: Support
tags: [firewall, agent, ports, 15778, 15779, terminal, setup, assessment]
---

## Symptom
- A track or lab with a new custom image fails to start: setup never completes and the terminal does not open.
- Or a running session freezes mid-way: the web terminal disconnects and grading or checks stop working, while the VM itself stays healthy. In two cases this hit a timed assessment, and the candidate's score reflected the lost agent, not their work.

## Cause
A firewall on the VM (for example one enabled by a setup script or baked into the image) blocks TCP ports 15778 and 15779, which the Instruqt agent uses to talk to the sandbox host. Enabling the firewall during a session cuts the agent connection and it cannot recover.

## Fix / workaround
1. Allow TCP 15778 and 15779 in the image or the track setup script before the firewall is enabled.
2. Document in the track or assessment brief that these ports must stay open and that learners should not enable or reset the firewall.
3. A session that has already lost the agent usually cannot be recovered; the learner needs a fresh attempt. For a graded assessment, tell the owner the result may not reflect the candidate's work.

## Notes
Three tickets with the same cause, but all from Support analysis of logs; Engineering did not confirm in the threads, so Unverified. One customer had not confirmed the fix at close. Customer and assessment details left out on purpose. Check the network and host image docs for the current port list.
