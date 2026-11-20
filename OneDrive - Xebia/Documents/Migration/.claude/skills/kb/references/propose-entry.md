# Proposing a new KB entry

Use when an answer came from outside the Git KB, or a human reports a correction.

1. **Pick the folder and id.** `known-issues` (KI), `fixes` (FX), `platform-rules` (PR), `tracks-to-labs` (TL), `responses` (RS), `roadmap` (RM). Next number = highest existing id in that folder + 1. Check first that no existing entry covers it; update that file instead of adding a duplicate.
2. **Copy** `kb/_templates/entry.md` to `kb/<folder>/<id>-<slug>.md`.
3. **Fill it** from the sources:
   - `status: draft`, `last_verified:` and `verified_by:` blank.
   - `source:` list every link or path you used.
   - Symptom with the exact error text; cause or "unknown"; numbered fix or workaround.
   - `audience: internal` unless it is clearly a public, customer-safe fact (a reviewer decides).
   - Anonymise: remove customer names, emails, IDs, org-specific URLs from the body.
4. **Do not** set `verified`, `verified_by` or `last_verified`.
5. **Tell the user** the file path, which sources it rests on, any conflict between sources, and that a reviewer must verify it before it is used for customer-facing answers. Open a PR only if the user asks.
