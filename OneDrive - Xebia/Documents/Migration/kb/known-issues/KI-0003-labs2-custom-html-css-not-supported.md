---
id: KI-0003
title: Custom HTML and CSS are not rendered in Labs 2.0 instructions, notes and descriptions
category: known-issue
products: [labs2]
status: draft
audience: internal
source:
  - type: notion
    ref: https://app.notion.com/p/3e2fa4cf12ea805eb558f8263d6d13b5 (2.0 Pre launch week - Decision log & Known issues, last edited 2026-09-23)
last_verified:
verified_by:
owner: Support
tags: [labs2, content, html, css, ga]
---

## Symptom
Custom HTML or CSS added to a lab's instructions, notes or description tabs (or the lab description) is not rendered, so styled content from a Tracks 1.0 track looks plain after migration.

## Cause
Deliberate product decision for GA: not supported at launch. The team wants a native, first-class implementation (with white-labelling and styling options) and does not want users to rely on pasting HTML and CSS that would later have to be reverted. Most users do not use custom CSS or HTML.

## Fix / workaround
1. No workaround in the lab. Tell the customer it is planned post-GA as a native feature.
2. Ask for the customer's example use case; the team wants input on what they use custom HTML and CSS for.
3. When migrating a track, expect to remove or replace HTML and CSS in content.

## Customer-safe wording
Draft from the Notion page, not reviewed: "Labs do not render custom CSS and HTML at launch. We are creating a native version of this to come after GA, with additional white-labelling and styling available. Please reach out if you have an example use case or insights into what you would use custom CSS and HTML for." A person must approve before it is sent.

## Notes
Source is a pre-launch decision log (2026-09-23) and shows "unverified". Check whether this has changed since GA before use. Related: the labs2-migrate skill and guide for content conversion.
