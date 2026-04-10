# Story Consistency Checker

Audits all story files for number conflicts, date mismatches, reuse collisions, and factual drift. Maintains a canonical truth registry and flags when any file diverges.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (canonical index — check `key_numbers` per story, `canonical_numbers` registry, `purged_stories` list)
- Master Story Repository: `interview_prep/scripts/master_story_repository.md`
- Company Interview Scripts: `interview_prep/scripts/{company}_interview_questions.md`
- Company Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Favorite Product: `interview_prep/scripts/favorite_product.md`
- Source Materials: `sources/{active_user}/`
- Answer Files: `interview_prep/answers/*.md`
- CLAUDE.md: `CLAUDE.md` (canonical numbers)
- Progress: `interview_prep/progress.json`

## Canonical Truth Registry

**READ canonical numbers, purged stories, date registry, and product distinctions from `interview_prep/story_bank.json`.**

The story bank's `canonical_numbers` object is GROUND TRUTH. Any file that deviates from these is WRONG and must be flagged.

At minimum, the story bank should contain:
- **Products**: distinct products that must never be conflated (e.g., separate user counts, metrics, timelines)
- **Key Numbers**: canonical values for all metrics used in stories (ARR, conversion rates, timelines, etc.)
- **Purged Stories**: stories that must NEVER appear in any file
- **Date Registry**: correct year/timeline for each story or event

If `story_bank.json` does not contain a `canonical_numbers` section, warn the user and offer to build one from CLAUDE.md.

## Commands

Parse `$ARGUMENTS` to determine the command:

### (no arguments) — Full Consistency Audit

**Step 1 — Read All Story Files**

Read every file listed in Data Files above. For each file, extract:
- Every story mentioned (by name/number)
- Every number/metric cited
- Every date/year referenced
- Every product name and associated metrics
- TMAY versions

**Step 2 — Cross-Reference Against Canonical Registry**

Read `canonical_numbers` from `interview_prep/story_bank.json`. For each extracted fact, check against the canonical registry. Flag:
- **NUMBER MISMATCH**: File says X, canonical says Y
- **DATE MISMATCH**: File says year X, canonical says Y
- **PRODUCT CONFLATION**: Numbers from one product used for another
- **PURGED STORY**: A purged story appears
- **TMAY INCONSISTENCY**: Different TMAYs have conflicting facts

**Step 3 — Check Story Reuse**

Build a matrix: which stories appear in which files/questions/LPs/rounds.
Flag:
- **ROUND COLLISION**: Same story used for 2+ LPs in the same interview round
- **OVERUSE**: Story used for 4+ different questions
- **ORPHAN**: Story exists in master repo but isn't allocated anywhere

**Step 4 — Report**

## STORY CONSISTENCY AUDIT

**Files scanned:** {N} | **Stories tracked:** {N}

---

### Number Mismatches ({count})

- `{file}:{line}` -- says "{wrong}" should be "{right}"
- `{file}:{line}` -- says "{wrong}" should be "{right}"

### Date Mismatches ({count})

- `{file}:{line}` -- says "{wrong year}" should be "{right year}"

### Product Conflations ({count})

- `{file}:{line}` -- uses Product A numbers for Product B (or vice versa)

### Purged Stories Found ({count})

- `{file}:{line}` -- Purged story reference MUST BE REMOVED

### TMAY Inconsistencies ({count})

- `{file1}` says "{X}" but `{file2}` says "{Y}"

### Reuse Collisions ({count})

- Story "{name}" used in Round {X} ({LP1}) AND Round {X} ({LP2})

### Overused Stories

- Story "{name}": used {N} times -- consider diversifying

### Orphan Stories

- Story "{name}": in master repo but not allocated to any question

---

*If clean:* **ALL CLEAR -- no inconsistencies found.**

*If issues:* **{N} issues found. Run `/story-check fix` to auto-repair.**

### `fix` — Auto-Fix All Flagged Issues

For each flagged issue from the last audit:
1. Show the exact text that needs changing (before/after)
2. Apply the fix
3. Report what was changed

Do NOT fix reuse collisions or orphans automatically — those require the user's judgment. Only fix factual errors (numbers, dates, product names, purged stories).

### `<story_name>` — Check One Story Across All Files

Find every mention of a specific story across all files and verify consistency.

### `numbers` — Numbers-Only Audit

Quick check: just scan all files for the canonical numbers and flag mismatches. Fastest audit mode.

### `reuse` — Reuse Matrix Only

Build and display the full story reuse matrix without running other checks.

## Key Rules

- The canonical numbers in `interview_prep/story_bank.json` are the source of truth. Period.
- When in doubt about a number, check `sources/{active_user}/` docs
- Never silently fix things — always show before/after
- Run this check BEFORE any interview (integrate into /prep-check)
- If a new canonical fact is established during a session, the user should say "add to canonical" and story_bank.json should be updated
