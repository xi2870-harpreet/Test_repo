---
id: FX-0001
title: GKE node(s) have low disk space (runbook)
category: fix
products: [cloud]
status: draft
audience: internal
source:
  - type: notion
    ref: https://app.notion.com/p/5a1d741dea0f44c0a6d725deb0061e77 (Support Engineering / Runbooks, last edited 2026-11-17)
last_verified:
verified_by:
owner: Support
tags: [gke, node, disk, alert, runbook]
---

## Symptom
The "GKE node(s) have low disk space" alert fires. It most often hits participant nodes in the participants prod project, where many different container images are pulled onto the nodes over time. The alert threshold equals the kubelet garbage-collection limit, so automatic cleanup is no longer keeping up.

## Cause
Cached container images fill the node disk. Automatic image pruning is on (above 85% disk usage, the GCP default), but the node has already passed that point.

## Fix / workaround
1. **Cordon the node immediately.** Request the `container-admin` entitlement in Google Cloud Privileged Access Manager (correct project: the participants prod project for participant nodes, the main prod project otherwise; auto-approved with a business justification). Then get cluster credentials, run `kubectl cordon <NODE_NAME>`, and confirm `Ready,SchedulingDisabled`. The node name is in the alert.
2. **Investigate.** Request the `sandbox-access-participants` entitlement (or the matching one for the project), then SSH to the node (Cloud Console SSH button, or `gcloud compute ssh <INSTANCE> --zone=<ZONE> --project=<PROJECT>`). Find the zone from the VM list or the node label `topology.kubernetes.io/zone`.
3. **Remove unused images.** `crictl images`; consider images over about 1 GiB. Confirm no pod uses an image before `crictl rmi <IMAGE_ID>`. The runbook notes this is more theoretical than practical because automatic pruning already runs.
4. **Verify.** `df -h /`. If still low, `du -sh /var/lib/containerd/* | sort -rh | head -20`.
5. **Recover.** `kubectl uncordon <NODE_NAME>` once disk space is healthy.

## Notes
Imported from one Notion runbook (shows "unverified"). Commands, project names and entitlement names must be checked by a reviewer against current infrastructure before this is relied on. Needs privileged access (PAM), so it is for Support Engineering, not L1.
