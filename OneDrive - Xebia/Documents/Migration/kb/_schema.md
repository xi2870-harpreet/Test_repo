# Entry schema

Each entry is one Markdown file with this front matter, then a body.

```yaml
---
id: KI-0001                 # prefix by folder: KI known-issues, FX fixes, PR platform-rules, TL tracks-to-labs, RS responses, RM roadmap
title: Short, searchable title
category: known-issue | fix | platform-rule | tracks-to-labs | response | roadmap
products: [tracks1, labs2, cloud, live-event]   # any that apply
status: draft | open | workaround | fixed | wontfix | verified   # see below
audience: internal | customer                    # customer = safe to quote to customers
source:                     # at least one link or file path
  - type: linear | unthread | slack | notion | docs | pr | postmortem | file
    ref: <link or path>
last_verified: YYYY-MM-DD   # blank while status is draft
verified_by: <name>         # blank while status is draft
owner: <name or team>
tags: []
---
```

## Body sections
- **Symptom**: what the user or engineer sees (exact error text where possible)
- **Cause**: why it happens (or "unknown")
- **Fix / workaround**: numbered steps
- **Customer-safe wording**: only if `audience: customer`; plain, no internal names
- **Notes**: dates, versions, related entries

## Statuses
- `draft`: proposed, unverified. Internal hint only.
- `open`: confirmed, no fix yet.
- `workaround`: confirmed, workaround exists.
- `fixed`: fixed in platform; keep for older sessions and customers on old versions.
- `wontfix`: confirmed, will not be fixed.
- `verified`: a platform rule or fix a reviewer has confirmed against current behaviour.

## Rules
- Anonymise before writing: no customer names, emails, IDs, org-specific URLs. Keep ticket or thread links only in `source`.
- Stale = `last_verified` older than 90 days. Stale entries are returned with a warning and re-checked.
- One issue per file. File name: `<id>-<slug>.md`.

## Tags
Start small and clean up before triage (initiative A) depends on them. Proposed first set:
`sandbox`, `cloud-account`, `aws`, `azure`, `gcp`, `vm`, `container`, `script`, `check-solve`, `setup`, `terminal`, `layout`, `module`, `migration`, `live-event`, `auth`, `billing`, `docs-gap`.
