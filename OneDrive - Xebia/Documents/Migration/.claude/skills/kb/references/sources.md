# Fallback sources (in order of trust)

Search these only when the Git KB has no verified, non-stale hit. All read-only. Use the tools the session lists; if a connector is missing or failing, say which one and carry on with the others. This KB is for the Support team, so every team tool below is in scope except Gmail (excluded: customer data, no shared access).

| Order | Source | Trust | Use it for | How |
|---|---|---|---|---|
| 1 | Git KB (`kb/`) | Highest | Primary answer | Grep and open files |
| 2 | Public docs (see "Public docs" below) | High for documented behaviour | Official behaviour, links to give customers | Fetch the live page; use `llms.txt` or the site search for the error text or feature name |
| 3 | Linear | Medium (status changes) | Known issue state (open/fixed), roadmap, Customer Insights | Search issues by error text, feature name, labels such as known issue; read status and comments for the current state |
| 4 | Unthread knowledge base | Medium-high (curated articles) | Articles already written for customers and the team | `search_knowledge_base` with the question; `list_knowledge_base_articles` to enumerate |
| 5 | Unthread tickets | Medium (may be a workaround) | Past fixes, similar tickets | `list_conversations` with `search`, resolved and open; read the summary and messages for the resolution, not just the title. Tags such as "KB" mark tickets worth turning into entries |
| 6 | Notion (see "Notion pages" below) | Medium (can be stale; pages show "unverified") | Internal process, runbooks, known issues and workarounds, release and decision logs | `notion-search`, then `notion-fetch`; check last-edited date |
| 7 | Google Drive (Docs, Slides, Sheets) | Medium (check last-edited date) | Plans, runbooks, decks, trackers | Drive search by title and content; read the file |
| 8 | Meeting notes and transcripts | Low-medium (spoken, unverified) | Engineers' tacit knowledge, decisions, "why" behind a fix | List and read meetings by topic; quote only what is stated |
| 9 | Slack | Lower (noisy) | Candidate fixes only | Internal support channels only. Customer channels are skipped unless a sample shows answers missing from Unthread. Read the full thread; an accepted answer is confirmed working or links to a resolved ticket |
| E | GCP logs and BigQuery | High as evidence, not a stated fix | Check whether an error really occurs in prod, how often, since when | Query only to confirm a symptom (Logging query on the error text; BigQuery read-only). Report counts and time range, never user data |
| E | GitHub (platform repos, PRs, release notes) | High for behaviour | What the code does, whether a fix merged | Search code and PRs. Connector currently fails to authenticate; say so and skip |
| E | Google Calendar | Low, context only | Release and live-event dates | Read events only when timing matters |

Rows marked E are evidence sources: use them to confirm or date an answer, not as the only source of one.

## Public docs
- **Labs 2.0:** https://docs.labs.instruqt.com. Sections: Introduction, What's New in 2.0, Getting Started, AI Lab Generation, UI Overview, Version Control, Reporting and Logs, Sharing, Session Limits, Integrations (LTI, Webhooks), Building Blocks (Modules, Secrets, Tags, Image builder), Settings (Roles, SSO, API Keys), Lab Development, Reference (Content, Sandbox, Configuration Types, Functions). Search box on the site; no sitemap or llms.txt found.
- **Tracks 1.0 and platform:** https://docs.instruqt.com. Has `https://docs.instruqt.com/llms.txt` (page index) and a Markdown version of any page by appending `.md` to its URL. Prefer these for searching and fetching.
- Pick the site by product: `labs2` uses the Labs site, `tracks1` and `cloud` use docs.instruqt.com. When unsure, check both.

## Notion pages
Known useful pages (search by title; do not rely on the links staying valid):
- **Known Issues / Workarounds** (Process): standard responses and workarounds, last edited 2026-06-08.
- **Runbooks** (Support Engineering), for example **GKE node(s) have low disk space**: diagnosis and fix steps.
- **Live Event Support: Engineering readiness with Claude Code** (Processes): describes the known-risks and known-failures files that feed this KB.
- **2.0 Pre launch week - Decision log & Known issues** (Document Hub): 2.0 decisions and launch-time limits.
- **L2 After Hours**, **Support Review Process** (Support Engineering): process, not fixes.
- Weekly support logs and personal testing logs: context only; do not cite as a fix.

All Notion pages currently show "unverified", so a Notion-only answer is Unverified.

## Rules for fallback results
- Quote the exact error string when searching; fall back to keywords.
- Note the date of each source. Anything older than the platform's latest relevant change is suspect.
- A single Slack, ticket, Notion or transcript answer is Unverified. Two independent sources that agree are Corroborated. Two copies of the same origin (a ticket and a Notion page quoting it) count as one.
- Evidence rows (logs, GitHub, calendar) can support a label but never raise a single-source answer to Verified.
- Never paste customer data into your answer or into a drafted entry. Ticket summaries are already anonymised; read full threads only when needed and strip names, emails and IDs.
