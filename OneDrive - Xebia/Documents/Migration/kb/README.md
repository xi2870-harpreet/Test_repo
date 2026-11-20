# Support Knowledge Base (1KB)

One versioned, verified knowledge base behind every Support skill. Markdown only, changed by pull request.
Plan: "One Knowledge Base Behind Every Skill" (Google Doc "Customer Support - One Knowledge Base (1KB)").

## Layout
| Folder | Holds |
|---|---|
| `known-issues/` | One file per known issue (symptom, cause, status) |
| `fixes/` | Troubleshooting steps and log-analysis guides |
| `platform-rules/` | Behaviour, limits, quotas |
| `tracks-to-labs/` | Shared Tracks 1.0 to Labs 2.0 gotchas |
| `responses/` | Approved customer replies; `responses/examples/` holds good and bad examples |
| `roadmap/` | Roadmap questions and answers |
| `_templates/entry.md` | Copy this to start an entry |
| `_schema.md` | Entry format, statuses, tags, rules |

## Rules (short)
1. Every entry has a source and a `last_verified` date. Older than 90 days = stale.
2. Entries change only by pull request; a named reviewer verifies.
3. Shared knowledge lives here only. Skill-specific files stay in their skill and link to entries.
4. Customer-facing text lives only in `responses/` and is always human-approved.
5. Anything with `status: draft` is internal only; customer-facing skills never use it.

Use it through the `kb` skill (`.claude/skills/kb`).
