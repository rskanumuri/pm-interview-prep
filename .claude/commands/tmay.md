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

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company>` — TMAY Practice for Company

**Step 1 — Show Current TMAY**

Search for the company's TMAY in this order:
1. Company cheat sheet (`scripts/{company}_cheat_sheet.md`) — look for TMAY section
2. Why scripts (`scripts/why_company_role_scripts.md`) — look for company entry
3. Source materials in `sources/{active_user}/` — base TMAY

Display:

## TMAY — {Company} (current version)

{Full TMAY text}

---

**Target:** 90 seconds | **Key numbers:** {list 3-4 from story_bank.json canonical_numbers}

*Your turn -- deliver it and I'll rate.*

**Step 2 — Rate the User's Attempt**

After the user delivers (pasted text or described), score on these dimensions:

| Dimension | Score /10 | Notes |
|-----------|-----------|-------|
| Hook (first 10 sec) | X | Did it grab attention? |
| Career Arc | X | Clear thread, not a resume recitation? |
| Numbers & Impact | X | Specific, memorable, correct? |
| Company Tailoring | X | Bridges to THIS role specifically? |
| Closing Offer | X | Ends with what user brings to THEM? |
| Timing | X | ~90 seconds? Too long/short? |
| **Overall** | **X** | |

**Specific checks:**
- Does it lead with business impact, not technology?
- Does it avoid introducing with what the user lacks?
- Are the numbers CORRECT per canonical_numbers in story_bank.json?
- Verify all numbers match `canonical_numbers` in `interview_prep/story_bank.json` — flag any discrepancy
- Does pilot come before scale where applicable?

**Step 3 — Suggest Improvements**

Show specific text changes:

- **BEFORE:** "{exact text that needs fixing}"
- **AFTER:** "{improved version}"
- **WHY:** {1-sentence reason}

**Step 4 — Ask to Update**

"Want me to update the {company} cheat sheet with these changes?"

If yes, update the TMAY section in the appropriate file and run save-push behavior.

### `compare` — Side-by-Side TMAY Comparison

Show all company-specific TMAYs side by side to identify:
- Inconsistent numbers across versions
- Missing company tailoring
- Reused phrases that should be unique

### `base` — Show/Edit Base TMAY

Show the base TMAY from source materials. This is the template all company versions derive from.

## TMAY Quality Rules

These are non-negotiable:

1. **Verify numbers match canonical_numbers in story_bank.json** — flag any discrepancy immediately
2. **Products must not be conflated** — check story_bank.json for distinct product boundaries
3. **Education must match resume exactly** — never embellish or change degree/school
4. **Two products to be proud of**: always include both with transition phrase
5. **End with offer**: what the user brings to THIS company specifically
6. **Score on /10 scale**
