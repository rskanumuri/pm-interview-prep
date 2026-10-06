---
description: "Map the core stories to the interview themes of a company and write the angles back to the master repo."
---

# Story-to-Company Mapper

Maps the user's core STAR stories to a company's interview themes. Reads source docs and story_bank.json to build the story inventory, then maps each story to company-specific interview dimensions.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (canonical story index — all stories with themes, question_types, company_angles. READ THIS FIRST for story inventory instead of scanning multiple source files.)
- Performance Kit: `sources/{active_user}/interview_performance_kit_v2.txt` (TMAY, STAR verbal scripts, walkthroughs)
- Company guides: `sources/{company}/...` (as needed)
- Resume: `sources/{active_user}/resume.txt`
- Proof Points: `sources/{active_user}/proof_points_by_role.md` (company meta-skills mapping)
- Master Stories: `interview_prep/scripts/master_story_repository.md` (full narratives — use for prose, not inventory)
- Company Insights: `interview_prep/insights/{company}.md`
- Company Rubric: `interview_prep/rubrics/{company}.md`
- Company Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md`
- Progress: `interview_prep/progress.json` (scores, flagged stories)
- Session Data: stale cache, do not use for the user's stories

## Story inventory

Do not keep a table here (the old one went stale: wrong count, unverified numbers). Read the inventory from `interview_prep/story_bank.json` (`stories[]` with `key_numbers`, `themes`, `question_types`, `company_angles`, `performance`). Numbers come from `canonical_numbers` and are worded per `canonical_provenance`.

## Multi-Role File Keying

When reading/writing company-keyed files (cheat sheet story map section, angles in master_story_repository.md), follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". This command accepts an optional `<role>` arg; when provided, read/update `{company}_{role_slug}` entries, else fall back to `{company}`. When seeding angles in master_story_repository.md, qualify the company column with the role name if role was provided (e.g., "Stripe / ML Foundations").



Parse `$ARGUMENTS` to determine the command:

### `<company>` — Generate Story Map

Create a Story Map table mapping the user's stories to the company's interview themes.

**Steps:**

1. **Read story_bank.json** to get current story inventory with details
2. **Read the user's source docs** for any stories not yet in the bank
3. **Read company artifacts:**
   - `interview_prep/insights/{company}.md` — what interviewers look for
   - `interview_prep/rubrics/{company}.md` — scoring dimensions
   - `interview_prep/scripts/{company}_cheat_sheet.md` — if exists, check existing story map
4. **Read progress.json** for story scores and flagged items
5. **Identify company interview themes** from insights and rubric:
   - What dimensions does this company score on?
   - What values do they emphasize?
   - What question types are likely? (behavioral, case, product sense, strategy)
6. **Map stories to themes** — for each theme, pick the best 1-2 stories:
   - Consider: relevance to theme, story strength (score from progress.json), whether it's been flagged
   - Consider: bridge quality — how naturally does this story connect to the company's domain?
   - Avoid: overusing one story, using flagged/weak stories as primaries

7. **Display the Story Map:**

> **Bridge** = the single sentence that connects a story's accomplishment to this company's specific problem (what they should DO, not a metric restatement). A strong bridge makes the story feel chosen for them, not reused.

## STORY MAP — {Company}

| Theme / Likely Question | Primary Story | Backup Story |
|------------------------|---------------|--------------|
| **{Theme 1: e.g., Scale}** | {Story name} -- {key metric} | {Story name} -- {key metric} |
| | Bridge: {1 line} | Bridge: {1 line} |
| **{Theme 2: e.g., Technical}** | {Story name} -- {key metric} | {Story name} -- {key metric} |
| | Bridge: {1 line} | Bridge: {1 line} |
| **{Theme 3: e.g., Leadership}** | {Story name} -- {key metric} | {Story name} -- {key metric} |
| | Bridge: {1 line} | Bridge: {1 line} |
| **{Theme 4: e.g., Customer}** | {Story name} -- {key metric} | {Story name} -- {key metric} |
| | Bridge: {1 line} | Bridge: {1 line} |
| **{Theme 5: e.g., Innovation}** | {Story name} -- {key metric} | {Story name} -- {key metric} |
| | Bridge: {1 line} | Bridge: {1 line} |

---

### Gap Coverage

- {theme with weak coverage}: Best available is {story} but bridge is thin
  - Bridge strategy: "{adjacent experience -> how I'd think about it}"

### Story Usage

- **Most used:** {Story name} (3 themes) -- OK, it's versatile
- **Unused:** {stories not mapped} -- consider for follow-ups
- **Flagged:** {stories below target score} -- drill before using

8. **Optionally inject into cheat sheet** — if `interview_prep/scripts/{company}_cheat_sheet.md` exists and has a Story Map section, offer to update it with this mapping.

8. **Write back company angles to `story_bank.json` (canonical)** — After generating the story map, offer: "Update story_bank.json with these company angles?"
   - If yes, for each story mapped above, update `company_angles[{company_key}]` in `story_bank.json`:
     - New company: add `{frame, bridge, planned_round, tested: false, score: null}` from the mapping.
     - Company already present: update `frame` and `bridge` ONLY. NEVER reset `tested`, `score` or any tested-round history; a prior "Yes (Round 2)" and its score stay exactly as they are. (The old version of this step reset Tested to No and destroyed scores.)
   - Show the exact before/after for each changed entry and wait for the user's yes before writing.
   - Check each bridge against `canonical_provenance` and `purged_stories` before writing. A bridge that breaks one is not written; flag it.
   - Then offer the mirror edit to the Company-Specific Angles table in `master_story_repository.md` (same rule: never overwrite a tested row), and offer `/story-bank refresh` to regenerate `story_bank.md`.
   - After writing, confirm: "Updated company angles for {N} stories in story_bank.json"

### `inventory` — Full Story Inventory

Show all stories with usage count across all companies.

**Steps:**
1. Read story_bank.json for the full story list
2. Read all cheat sheets: `interview_prep/scripts/*_cheat_sheet.md`
3. Read progress.json for scores
4. Count how many company story maps each story appears in
5. Display:

## STORY INVENTORY

| Story | Score | Reps | Used In | Status |
|-------|-------|------|---------|--------|
| {Story 1} | 4.3 | 12 | {companies} | Locked |
| {Story 2} | 4.0 | 5 | {companies} | Ready |
| {Story 3} | 3.8 | 4 | {companies} | Below target |
| {Story 4} | 3.5 | 3 | -- | Flagged |
| {Story 5} | -- | -- | -- | Not drilled |

**Legend:** At target = 4.0+ | Below target = <4.0 | Flagged = needs work | Not drilled = no reps

### `gaps` — Coverage Gap Analysis

Find interview themes across all active companies that don't have strong story coverage.

**Steps:**
1. Read all company insights and rubrics for active companies (those in progress.json with status not containing "REJECTED" or "DROPPED")
2. Compile all interview themes/dimensions across companies
3. Check which themes have strong story coverage vs weak/no coverage
4. Display:

## STORY COVERAGE GAPS

### Well Covered (strong story + bridge)

- **{Theme}** -> {Story name} ({key metric})
- **{Theme}** -> {Story name} ({key metric})

### Thin Coverage (story exists but bridge is weak)

- **{Theme}** -> no direct story, bridge through {adjacent experience}

### No Coverage (no matching story)

- **{Theme}** -> HONEST GAP, bridge only

### Recommendations

- Develop bridge scripts for thin coverage areas
- Practice gap-bridging for no-coverage areas
- Consider: can any existing story be reframed?

## Key Rules

- **Read `story_bank.json` every time** — it is the inventory; do not rely on memory or a copied table
- **Score-aware mapping** — prefer stories at 4.0+ target; flag stories below target
- **Bridge quality matters** — a strong story with a weak bridge is worse than a decent story with a natural bridge
- **Don't overload one story** — if one story appears in 4+ themes for one company, flag it
- **Flagged stories** from progress.json should be marked and deprioritized as primaries
- **Numbers come from the canon** — every mapping includes the story's metric from `canonical_numbers`, worded per `canonical_provenance`. If a story's number is marked OPEN there, write "no number to quote" instead of using it
- **Gap honesty** — if there's no good story for a theme, say so and provide a bridge strategy rather than force-fitting
