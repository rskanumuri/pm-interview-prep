---
description: "Practice loop for the Tell Me About Yourself answer that shows it, rates it, fixes it, and updates the cheat sheet."
---

# TMAY — Tell Me About Yourself Practice Loop

Focused TMAY iteration for any company. Show current version, accept the user's verbal attempt, rate it, suggest fixes, update the file.

## Data Files

- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Company Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- Source Materials: `sources/{active_user}/` (performance kit with TMAY versions)
- Master Story Repository: `interview_prep/scripts/master_story_repository.md`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers for verification)
- Proof Points: `sources/{active_user}/proof_points_by_role.md` (company-specific signals to weave into TMAY)
- CLAUDE.md: `CLAUDE.md` (company context, key numbers)

## Multi-Role File Keying

When reading company-keyed files to surface a company-specific TMAY hook, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, use role-keyed artifacts, else fall back to `{company}_*`. Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<company>` — TMAY Practice for Company

**Step 1 — Show Current TMAY**

Search for the company's TMAY in this order:
1. Company cheat sheet (`scripts/{company}_cheat_sheet.md`) — look for TMAY section
2. Why scripts (`scripts/why_company_role_scripts.md`) — look for company entry
3. Source materials in `sources/{active_user}/` — base TMAY

**Canon check BEFORE displaying (mandatory).** Scan the TMAY text against `story_bank.json` `canonical_numbers`, `canonical_provenance` and `purged_stories` (the `/story-check` rules). On any drift, print "DRIFT IN PREP: {line} -> {canonical wording}" above the TMAY and show the corrected wording. Never display drifted text as the version to internalize. If a number is marked OPEN in provenance, print "do not quote".

Display:

## TMAY — {Company} (current version)

{Full TMAY text}

---

**Target:** about 90 seconds (roughly 190-225 spoken words) | **Key numbers:** {3-4 from `canonical_numbers`, each with its provenance phrasing}

*Your turn -- deliver it and I'll rate.*

**Step 2 — Rate the User's Attempt**

After the user delivers (pasted text or described), score on these dimensions:

| Dimension | Score /10 | Notes |
|-----------|-----------|-------|
| Opener (first sentence) | X | Does sentence one answer "tell me about yourself" with impact, not a resume line? |
| Career Arc | X | Clear thread, not a resume recitation? |
| Numbers & Impact | X | Specific, memorable, correct? |
| Company Tailoring | X | Bridges to THIS role specifically? |
| Closing Offer | X | Ends with what the user brings to THEM? |
| Length | X | Word count of the pasted text vs about 190-225 words. State the count. Judge from text only; delivery pace and pauses cannot be scored from pasted text. |
| **Overall** | **X** | |

Anchors (same as `/drill-rapid`): 9-10 usable in a real loop as-is; 7-8 solid with one or two fixes; 5-6 right content but weak delivery or missing numbers; under 5 wrong or rambling. **Number cap:** a number that breaks canon or a provenance ruling caps Overall at 6 and is named. Scores are computed, never copied from an example. Save `score_10` and `score_5 = score_10 / 2`.

**Specific checks:**
- Does it lead with business impact, not technology? (Rule #1)
- Does it avoid introducing with what the user lacks? (Rule #2)
- Does it avoid framing the user's previous employer as a consolation prize? (Rule #3)
- Are the numbers CORRECT per `canonical_numbers` AND said the way `canonical_provenance` allows (units, denominators, distinct products not conflated)? Name any break; it caps Overall at 6.
- Does pilot come before scale? ("pilot to paid conversion first, then 25 countries")

**Step 3 — Suggest Improvements**

Show specific text changes:

- **BEFORE:** "{exact text that needs fixing}"
- **AFTER:** "{improved version}"
- **WHY:** {1-sentence reason}

**Step 4 — Ask to Update**

"Want me to update the {company} cheat sheet with these changes?"

If yes, show the before/after, update the TMAY section in the appropriate file, and OFFER `/save-push` (do not push on your own).

### `compare` — Side-by-Side TMAY Comparison

Show all company-specific TMAYs side by side to identify:
- Inconsistent numbers across versions
- Missing company tailoring
- Reused phrases that should be unique

### `base` — Show/Edit Base TMAY

Show the base TMAY from source materials. This is the template all company versions derive from.

## TMAY Quality Rules

These are non-negotiable based on the user's feedback patterns:

1. **Pilot first, scale second**: the pilot-to-paid conversion (with its base, about 8 pilots) before "25 countries"
2. **Numbers come from the canon, not from this file**: read `story_bank.json` `canonical_numbers` and `canonical_provenance` and check every number the user says against them, including units, denominators, and tenure dates.
3. **Never say** anything that contradicts `canonical_numbers` (for example tenure or education claims) or any purged story.
7. **Two products to be proud of**: always include both with transition phrase
8. **End with offer**: what the user brings to THIS company specifically
9. **Score on /10 scale** (the user's preference)
