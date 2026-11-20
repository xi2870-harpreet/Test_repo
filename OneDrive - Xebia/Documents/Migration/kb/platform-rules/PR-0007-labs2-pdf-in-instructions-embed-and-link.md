---
id: PR-0007
title: Labs 2.0 instructions: no PDF download button; embed the PDF and add a link to /assets
category: platform-rule
products: [labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: ticket 4483 (closed 2026-11-12)
last_verified:
verified_by:
owner: Support
tags: [labs2, instructions, pdf, assets, markdown]
---

## Rule
There is no download button for PDFs in lab instructions. Two ways to share one:
1. Upload the PDF under Asset, Upload new asset.
2. Embed it inline with `<instruqt-pdf url="/assets/your-file.pdf"></instruqt-pdf>`.

For a direct or larger view, add a Markdown link in the instructions: `[Open the PDF](/assets/your-file.pdf)`. In Support's testing it opens the PDF in a new tab.

## Notes
One ticket, so Unverified. The link behaviour is from a Support test, not from Engineering or the docs. Check the docs for the current embed syntax and whether a download option has shipped. Customer details left out on purpose.
