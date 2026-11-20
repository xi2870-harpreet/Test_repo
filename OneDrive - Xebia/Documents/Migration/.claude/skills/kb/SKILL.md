---
name: kb
description: Answer Support questions (known issues, fixes, platform rules, Tracks-to-Labs gotchas, roadmap, approved responses) from the shared Support knowledge base first, then fall back to public docs, Linear, Unthread (KB and tickets), Notion, Google Drive, meeting notes and Slack, with logs, BigQuery and GitHub as evidence. Use when asked "is this a known issue", "how do we fix X", "what does the platform do when Y", when triaging a ticket, or when another skill needs a verified Support fact. Returns cited answers with a confidence label and proposes new entries as draft pull requests.
---

# kb: one knowledge base behind every skill

Other skills call this one instead of reaching into Slack, Linear, Unthread, Notion or the docs themselves.
The base KB lives in the `kb/` folder at the repo root (`KB_ROOT`; use another path if the KB repo is cloned elsewhere). Read `kb/_schema.md` for the entry format. Read `references/sources.md` for how to query each fallback source and `references/propose-entry.md` before drafting an entry.

## Inputs
- `question`: the issue, error text, ticket, or fact needed.
- `product` (optional): `labs2`, `tracks1`, `cloud`, `live-event`.
- `audience` (optional, default `internal`): `internal` or `customer`. Customer-facing callers get Verified entries and public docs only.

## How to answer

1. **Search the Git KB first.** Grep `kb/` for exact error strings, then keywords and tags; filter by `products`. Open every plausible entry in full.
   - Verified, non-stale hit (`status` not `draft`, `last_verified` within 90 days): answer from it. Stop searching unless asked for more.
   - Stale hit (older than 90 days): use it, flag it stale, and re-check it against public docs and Linear.
   - `draft` hit: internal hint only, label it Unverified.
2. **No hit (or stale)? Fall back in order of trust:** public docs, Linear, Unthread KB, Unthread tickets, Notion, Drive, meeting notes, Slack (see `references/sources.md`). Use logs, BigQuery and GitHub to confirm or date an answer. Gmail is out of scope. All fallback sources are read-only.
3. **Reconcile.** If sources disagree (docs say supported, Linear shows a bug), say so and cite both. Never merge silently. Prefer the newer, higher-trust source and say why.
4. **Label confidence:**
   - **Verified**: a non-stale KB entry a reviewer confirmed.
   - **Corroborated**: two or more independent sources agree.
   - **Unverified**: one source only (typically Slack or a single ticket), or a draft entry.
5. **Return** the answer, confidence label, citations (links or file paths with entry ids), any conflicts, and what a human should verify.
6. **Propose an entry** if the answer came from outside the KB (steps in `references/propose-entry.md`). Draft only; do not commit or push unless the user asks.

## Output format
```
Answer: <short, direct>
Confidence: Verified | Corroborated | Unverified
Sources: <KB entry ids / links>
Conflicts: <none, or what disagrees>
Next: <what to verify, proposed entry file if any>
```

## Guardrails
- **Customer-facing use:** only Verified KB entries and public docs. Unverified or Slack-only findings go to L1/L2 as hints, never into a customer reply. Customer wording comes from `responses/` or an entry's "Customer-safe wording", and a person approves every customer-facing message.
- **Read-only** on Slack, Linear, Unthread, Notion and the docs. The only write is a new draft file in `kb/` (for a pull request).
- **Anonymise** before writing anything to `kb/`: no customer names, emails, IDs or org-specific URLs in the body. Links to tickets and threads go only in `source`.
- **Cite everything.** An uncited fact is not an answer.
- **Check public docs for freshness each use** by fetching the page, not relying on a remembered copy.
- Skill-specific knowledge (for example `labs2-migrate/LEARNINGS.md`) stays in its own skill. Link to KB entries where they overlap; do not duplicate shared knowledge.
- Never mark an entry `verified`, or fill `verified_by` / `last_verified`, yourself. Only a human reviewer does.

## When asked to update the KB
Human edits to an entry, and corrections found while answering, follow the same path: edit or draft the file, open a PR, a reviewer verifies, merge. Skills pick the change up on the next read.
