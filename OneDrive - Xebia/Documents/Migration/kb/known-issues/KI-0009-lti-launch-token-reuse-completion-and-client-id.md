---
id: KI-0009
title: LTI launches: invalid token on reused launch, completion not sent, duplicate client ID
category: known-issue
products: [tracks1, labs2]
status: draft
audience: internal
source:
  - type: unthread
    ref: tickets 4578, 4562 (closed 2026-11-25 to 2026-11-23)
  - type: unthread
    ref: tickets 4313, 4506 (closed 2026-11-04 to 2026-11-24)
last_verified:
verified_by:
owner: Support
tags: [lti, lms, launch, token, completion, resume, sso]
---

## Symptoms and causes
- **"Invalid token" on launch.** The learner reused a one-time launch token after the lab had been stopped. Fix: close the old tab and launch again from the LMS.
- **Completion not reported to the LMS.** A lab reached 100% but was marked stopped, not completed, so no grade was sent. In the same account, LTI 1.3 launches later failed because duplicate registrations shared one client ID; removing the duplicate restored launches. Each Instruqt team should use its own LTI 1.3 tool and client ID in the LMS.
- **Learner not recognised when resuming.** Sessions stay available for 7 days, but resume works only in the same browser while the play is active or paused. Anonymous learners are lost if browser storage is cleared, and the encrypted learner handoff does not identify returning learners.

## Workarounds
- Use the server-side `ltiLogin` API with a stable learner ID and pass its token as `id_token`. A customer's own SSO (for example Auth0) can override that token; logging out of it let the session transfer.
- Do not email a tokenized embed URL. Send learners to a customer-owned page with a personal link or login that recognises them and loads the embed. A request for secure resume links was logged with the product team.

## Notes
Four tickets, all from Support analysis, so Unverified. Check the LTI docs for the current client-ID and completion rules. Customer, LMS account and learner details left out on purpose.
