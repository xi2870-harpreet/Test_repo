# One Knowledge Base Behind Every Skill: Draft Plan

Status: DRAFT for Praveen's review. Source: "Customer Support: AI-First Plan", section 3.

## 1. Why

All six initiatives (A triage, B live events, C content review, D Labs 2.0 migration, E QA automation, F community knowledge center) need the same input: known issues, fixes, platform rules, Tracks-to-Labs gotchas, roadmap answers and approved responses. Today it is scattered, and two lessons from track building apply:

- The rulebook is the asset (about 66K to 115K characters, and later tracks got faster).
- Lessons kept in two places drift apart, and one copy went stale.

Goal: build it once, versioned, verified, and read by every skill.

## 2. What exists today (sources to consolidate)

| Source | Feeds |
|---|---|
| Track-building rulebook (about 115K chars) | C, D, F |
| Live event skill: known-risks and known-failures files | A, B, E |
| Labs 2.0 migration guide + `labs2-migrate` LEARNINGS.md (in this repo) | D, F |
| Linear Known issues history and Customer Insights | A, E, F |
| Resolved Unthread tickets (troubleshooting knowledge) | A, F |
| Slack history: customer channels where solutions were given (and internal support channels) | A, E, F |
| Public docs (docs.instruqt.com) | A, C, D, F |
| Notion (internal wikis, release docs, runbooks) | A, B, E |
| Engineers' experience (not written down) | all |

## 3. Design

**Repo:** one Git repo, Markdown only. Proposed layout:

```
kb/
  known-issues/        one file per issue
  fixes/               troubleshooting steps
  platform-rules/      behaviour, limits, quotas
  tracks-to-labs/      migration gotchas
  responses/           approved customer replies
  roadmap/             roadmap questions and answers
  _schema.md           entry format + tag taxonomy
```

**Entry format (front matter):**

```
id, title, category, products (tracks1|labs2|cloud|live-event),
status (open|fixed|workaround|wontfix),
source (Linear/Unthread/PR/postmortem link),
last_verified (date), verified_by, owner, tags
```
Body: symptom, cause, fix or workaround, customer-safe wording.

**Rules**
1. Every entry has a source and a last-verified date. Anything older than 90 days is flagged stale.
2. Changes only by pull request; a named reviewer verifies.
3. Skills read the KB (path or MCP/file reference), never keep their own copies. The skill's local known-risks and learnings files become pointers or are removed after migration.
4. Customer-facing text lives only in `responses/` and is always human-approved.

## 4. How skills use it

| Skill | Reads | Writes back (via PR) |
|---|---|---|
| A Triage | known-issues, fixes, responses, roadmap | new issue patterns from tickets |
| B Live events | known-issues, platform-rules | postmortem findings |
| C Content review | platform-rules, tracks gotchas | new check rules |
| D Migration | tracks-to-labs | per-track learnings |
| E QA | known-issues, platform-rules | bugs, doc gaps, Support notes |
| F Community | all verified, customer-safe entries | draft articles |

## 4b. Mining Slack history

Customer channels hold real solutions, but they are noisy and contain customer data. Approach:
1. Scope: list customer channels and an agreed date range; start with the top customers and most-asked topics.
2. Extract: for each thread with a support question and an accepted answer (confirmation, resolved reaction, or linked ticket), Claude drafts a candidate entry: symptom, cause, fix, source link to the thread.
3. Anonymise: strip customer names, emails, IDs and org-specific URLs; keep the source link only in the internal field.
4. Dedupe and cross-check against Linear/Unthread and existing entries; mark conflicts for a human.
5. Verify: an L2/SME reviews each batch by PR before merge; unverified Slack-derived entries stay `status: draft` and are not used by customer-facing skills.
6. Keep going: new solved threads propose entries on an ongoing basis (Slack thread to PR).

## 4c. The knowledge base skill (`kb`)

One skill that every other skill calls, instead of each skill reaching into Slack, Linear, Unthread, Notion and the docs itself.

**Sources it can search (read-only connectors):**

| Source | Via | Trust level | Use |
|---|---|---|---|
| Git KB (verified entries) | files | Highest: verified, dated | Primary answer |
| Public docs | web fetch / sitemap index | High for documented behaviour | Confirm official behaviour, link customers |
| Linear (Known issues, Customer Insights, tickets) | Linear connector | Medium: status changes | Open/fixed state, roadmap |
| Unthread (resolved tickets) | Unthread connector | Medium: may be workaround | Past fixes, ticket matches |
| Notion (wikis, release docs, runbooks) | Notion connector | Medium: can be stale | Internal process and release context |
| Slack (customer + support channels) | Slack connector | Lower: noisy, unverified | Candidate fixes only |

**How it answers a query:**
1. Search the Git KB first. A verified, non-stale hit is returned with its source and last-verified date.
2. If no hit (or stale), search public docs, Linear, Unthread, Notion, then Slack, in that order of trust.
3. Reconcile: if sources disagree (docs say supported, Linear says known bug), say so and cite both; never merge silently.
4. Return the answer with citations and a confidence label: Verified (KB), Corroborated (2+ sources), Unverified (single Slack/ticket source).
5. If it had to go beyond the KB, it drafts a new entry as a PR (status `draft`) for human verification, so the next query hits the KB.

**Guardrails:**
- Customer-facing skills (triage replies, community) only use Verified entries and public docs; Unverified results go to L1/L2 as hints only.
- Every cited fact links to its source; anonymise before anything is written to the KB.
- Read-only on all sources; the only write is a pull request to the KB repo.
- Public docs are checked for freshness on each use (compare against fetched page, not a cached copy).

**Interface:** `kb search <question> [--product labs2|tracks1|cloud|live-event] [--audience internal|customer]`, returning entries, citations, confidence and any conflicts.

## 5. Update loop

Postmortem, QA run, migration, resolved ticket or solved Slack thread → skill proposes a draft entry → PR → SME/L2 verifies → merge → all skills see it. Optional: scheduled weekly job lists stale entries and open proposals.

## 6. Phased plan

| Phase | Work | Output |
|---|---|---|
| 0 (week 1) | Agree schema, tag taxonomy, owners; inventory the sources above | `_schema.md`, source inventory |
| 1 (weeks 2-3) | Seed from what is already clean: migration guide + LEARNINGS, live-event known-failures/known-risks | about 50 verified entries |
| 2 (weeks 3-5) | Import Linear Known issues and Customer Insights; mine resolved tickets and Slack customer-channel threads for fixes; dedupe | known-issues + fixes populated |
| 2b (weeks 4-5) | Build the `kb` skill with connectors for Git KB, public docs, Linear, Unthread, Notion, Slack; test on 30 past tickets and compare answers to what L2 actually did | `kb` skill v1 + accuracy report |
| 3 (weeks 5-6) | Point triage (A) and migration (D) at the `kb` skill | A and D calling `kb` |
| 4 (Q1) | Point B, C, E at it; set up PR proposals from postmortems/QA; stale-entry report | closed update loop |
| 5 (Q1+) | Export verified, customer-safe entries to the community knowledge center (F) | published articles |

## 7. Measures

- Entries verified and the share not stale (under 90 days)
- Share of skill answers that cite a KB entry
- Tickets matched to an existing known issue
- Time to add a new lesson (incident to merged entry)
- Duplicate or conflicting entries (target: zero)
- `kb` answer accuracy against L2-reviewed sample, and share of answers resolved from the Git KB vs. fallback sources (should rise over time)

## 8. Open questions for Praveen

1. Which repo/org should host it, and who are the reviewers per category?
2. Rulebook: can it be moved in whole, or does it stay in the track-building repo with the KB linking to it?
3. How do skills access it: git submodule/clone, or an MCP/search layer? Start with plain files plus the `kb` skill.
3b. Do we have connector access for all sources (Slack, Linear, Unthread, Notion) in one place, and which accounts/permissions does the `kb` skill run under?
4. Which Unthread/Linear/Slack data can be copied in (customer names, confidentiality)? Entries should be anonymised. Are customer channels shared (Slack Connect) and do any restrictions apply?
5. Who owns the tag taxonomy clean-up that triage (A) depends on?

## 9. Risks

- Stale or wrong entries misleading every skill: mitigated by source + verified date + PR review.
- Low contribution: mitigated by skills drafting the PRs so humans only verify.
- Customer data leaking into entries: anonymise at import, human review of every Slack-derived batch.
- Slack answers that were workarounds or are now outdated: require a verified date and re-check against current platform behaviour.
