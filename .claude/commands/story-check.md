---
description: "Audit story files against the canonical numbers, provenance rulings, and purged-story list. Use for check numbers."
---

# Story Consistency Checker

Audits forward-looking story files for number conflicts, provenance violations, date and duration arithmetic errors, and factual drift. It does not keep its own copy of the numbers (that was the fourth copy and it drifted).

## Source of truth (read these, do not restate them here)

- `interview_prep/story_bank.json` → `canonical_numbers` (the values), `canonical_provenance` (what each value MEANS and how it may be said), `purged_stories`
- `CLAUDE.md` → "Story Integrity — Canonical Numbers" and the "Provenance rulings" block
- If the three disagree, flag it and ask the user. Do not pick one.
- A new ruling gets added to `story_bank.json` (`canonical_numbers` or `canonical_provenance`) and CLAUDE.md, never to this file.

## Scope

**Checked and fixable (forward-looking):** `interview_prep/scripts/` for companies not closed (`why_company_role_scripts.md`, `master_story_repository.md`, `startup_stories_db.md`, `favorite_product.md`, cheat sheets for open roles), `sources/{active_user}/` prep docs, `story_bank.json`.

**Checked and reported only, NEVER modified (historical record):**
- Anything in `interview_prep/answers/*` (debriefs)
- Any `*transcript*` file in `sources/`
- Any file under `sources/<company>/` for a company in `interview_prep/reference/closed_pipeline.md`
- `interview_lessons.md`, `career_takeaways.md`, `question_bank*.md`
Old values in those files were true when written. Report them under "Historical drift (not fixed)" so the user knows, and stop.

## Method: grep first, then read

Do NOT read every file. For each check below, run Grep across the scope, then read only the matching lines with 3 lines of context. A full read of a file happens only when a story name needs surrounding context. (The old "read everything" approach cost roughly 1 MB of tokens per run.)

## Checks

### 1. Number mismatch
Each `canonical_numbers` value against variants in the files (a retired or older figure, a wrong tenure, a wrong education claim, the same baseline stated per-query in one file and per-opportunity in another).

### 2. Provenance violation (the numbers are right but said wrong)
Flag any line that breaks a `canonical_provenance` ruling. Typical classes:
- An audience or reach figure described as current users ("built for N", not "serves N")
- A percentage without its denominator, or a rate described as a different metric than it is
- A result stated without the base it was measured on (for example a conversion rate with no pilot count)
- A baseline without its unit ("per question", "per opportunity")
- A counterfactual ("would have taken 9 months") told as an outcome ("took 9 months")
- A figure presented as measured when the ruling says estimated, target, or OPEN
- Ownership overstated or understated against the ownership ruling; flag both directions for the user to judge, never auto-fix

### 3. Arithmetic (compute, do not string-match)
- **Tenure**: use the employment dates in `canonical_provenance`. Flag durations that exceed them ("a year at a 9-month job") and any build, launch, and adoption arc that cannot fit inside the window.
- **Percent and counts**: if a file states both a user count and a percent, compute the implied denominator and flag a contradiction with the ruling. For conversion claims, compute converted/base and flag a percent that does not match the stated base.
Show the arithmetic in the report line.

### 4. Date mismatch
Against the story years in `story_bank.json`. Where two sources disagree, report the disagreement; do not fix either.

### 5. Product conflation
Numbers or claims of one product attributed to another, as recorded in `canonical_provenance`.

### 6. Purged story
Everything in `story_bank.json` `purged_stories`, including phrasing variants.

### 7. TMAY inconsistency
Different TMAY versions with conflicting facts.

### 8. Reuse (story_bank.json is the source)
Round collision (same story, 2+ LPs in one round), overuse (4+ questions), orphan (in the master repo but not in `story_bank.json` `company_angles`). Never auto-fixed.

## Date Registry
This skill keeps no copy of dates. Story years live in `story_bank.json`; employment windows live in `canonical_provenance`.

## Multi-Role File Keying

Follow the `{company_key}` convention in `CLAUDE.md` "Multi-Role File Keying". Treat each `{company}_{role_slug}` as its own scope; report drift per role.

## Commands

### (no arguments) — Full audit
Run checks 1-8 on the scope above using grep-first. Report:

## STORY CONSISTENCY AUDIT

**Files scanned:** {N} | **Mode:** grep-first

Then one section per check, each line `{file}:{line} -- says "{x}", canon "{y}"` (provenance lines name the ruling; arithmetic lines show the math). Then:

### Historical drift (not fixed)
Same format, for the report-only files.

*If clean:* **ALL CLEAR.** *If issues:* **{N} issues. Run `/story-check fix` to repair the fixable ones.**

### `fix` — Repair
1. Run the audit first, in this same invocation (there is no saved audit to resume).
2. Fixable = checks 1-6 findings in forward-looking files ONLY, where the right wording is unambiguous from `canonical_provenance`.
3. Show every exact before/after and wait for the user's yes. Then apply. Never silently fix.
4. Never touch the report-only files. Never auto-fix reuse, orphan, TMAY, date disagreements, or anything where the canon itself is "OPEN".
5. After applying, re-grep the changed lines to confirm and report the count.

### `<story_name>` — one story across files (grep by story name, then read matches)
### `numbers` — checks 1 and 2 only
### `reuse` — check 8 only

## Key Rules

- Provenance is part of correctness: a correct number said the wrong way is a finding.
- Compute, do not string-match, for tenure, arc, percents and counts.
- Historical files are reported, never edited.
- Run before any interview and from `/prep-check` (prep-check calls the `numbers` mode and shows the result).
- If a new ruling is established, the user says "add to canonical"; update `story_bank.json` and CLAUDE.md, not this file.
