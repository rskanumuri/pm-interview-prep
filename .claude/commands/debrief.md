---
description: "Interactive post-interview debrief that saves a structured file and updates progress and lessons."
---

# Post-Interview Debrief

Interactive guided debrief after each interview. Claude asks structured questions, the user answers conversationally, Claude formats everything into a structured debrief document.

**Read `interview_prep/reference/debrief_core.md` first.** It is the shared rulebook for transcripts, scoring, story-bank write-back, state writes, and career-learning hooks. Where it conflicts with this file, it wins.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

- Progress: `interview_prep/progress.json`
- Answers Directory: `interview_prep/answers/`
- CLAUDE.md: `CLAUDE.md` (project root)
- Companies Registry: `interview_prep/companies.json`
- Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md` (for pre-interview prep comparison)

## Multi-Role File Keying

When reading/writing company-keyed files (cheat sheet, debrief filename prefix), follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". This command accepts an optional `<role>` arg; when provided, debriefs save as `{company}_{role_slug}_{interviewer}_debrief_*.md`, else fall back to `{company}_*` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<company> [interviewer]` — Start Interactive Debrief

Run an interactive guided debrief session. Ask questions one at a time, wait for answers, then compile.

**Step 0 — Transcript (core §0):** check `sources/<company>/` for a saved transcript of this interview before asking anything. If none and a Granola meeting exists, pull it and save it verbatim. If there is no transcript at all, say so in the debrief header.

**Step 1 — Gather Context (ask these one at a time, conversationally):**

Let's debrief your {Company} interview. I'll ask a few questions and then compile everything.

1. Who did you interview with? (name, title, how long at company if known)
2. What round was this? (recruiter, HM, panel, final, etc.)
3. How long was it? Did you use the full time?
4. What was the format? (behavioral STAR, case study, product sense, strategy, technical, mixed)

Wait for answers, then continue:

5. What questions did they ask? (list as many as you remember)
6. What landed well? (moments where the interviewer engaged, nodded, asked follow-ups, said something positive)
7. What didn't land? (moments where you stumbled, got redirected, felt uncertain, or the interviewer seemed unconvinced)
8. Any direct quotes from the interviewer? (positive signals, concerns raised, next steps mentioned)
9. What new intel did you learn? (about the role, team, company, process, timeline)
10. What are the confirmed next steps? (who said what about moving forward)

Wait for answers, then ask for self-assessment:

11. How would you score yourself overall? (1-5 scale: 1=bombed, 3=50/50, 5=crushed it)
12. If you could redo one moment, what would it be?

**Step 2 — Read prep artifacts for comparison:**
- Read cheat sheet if it exists (to compare what was prepped vs what actually happened)
- Read progress.json for prior round data
- Read CLAUDE.md for company context

**Step 2.5 — Extract Story Angles (after gathering all answers):**

From the user's answers, identify which stories from `interview_prep/scripts/master_story_repository.md` were used:
- Which stories were told (match by name from master repo)
- What angle/frame was applied for this company
- Whether it landed (from "what landed" / "what didn't land" answers)
- Any new angle discovered (if interviewer's reaction suggested a better frame)

Add a "Story Angles Used" section to the debrief output:

## Story Angles Used

| Story | Angle Applied | Landed? | Notes |
|-------|--------------|---------|-------|
| {story name} | {frame used} | Yes/Partial/No | {what worked or what to adjust} |

After saving the debrief, write the angles to `story_bank.json` per core §2 (canonical). Offer the mirror edit to `master_story_repository.md`; never reset a prior `tested`/`score`.

**Step 3 — Generate debrief document:**

Create `interview_prep/answers/{company_key}_{interviewer}_debrief_{date}.md` following this structure:

**File header:**
- `# {Company} — {Interviewer Name} Debrief`
- **Date:** {date}
- **Round:** {X of Y}
- **Duration:** ~{duration} ({used full time? or ended early?})
- **Format:** {format description}
- **Overall Score:** {rubric-strict}/5.0 | Self-score: {self-score}/5.0 (see core §1)
- **Transcript:** {saved path, or "none; the user's recollection only"}
- **Outcome:** {next steps or "Awaiting"}

**Score Breakdown** — table with columns: Dimension, Weight, Score, Evidence. Rows come from the company rubric (core §1), including unattempted rows scored as such. List penalties applied. Use the generic five-dimension set only as a labeled last-resort fallback.

**Questions Asked** — numbered list with brief note on how each went

**What Landed** — bullet list of specific moments that worked

**What Didn't Land** — bullet list of specific moments that didn't work

**New Intel** — bullet list of role/team details, process/timeline, culture signals learned

**Key Lessons for Next Rounds** — numbered list of actionable lessons with specific fixes

**Prep vs Reality** — table with columns: Prepped For, What Actually Happened

**Prediction** — 1-2 sentence honest assessment of likelihood of advancing, based on signals

**Step 4 — Update progress.json:**

Show the diff first (core §3), then update the company_readiness entry (this company's keys only):
- Update `status` field with round result and next steps
- Update `percent` if appropriate
- Add round-specific fields (score, format, topics, strengths, gaps)
- Add `lessons_for_next_rounds` array
- Add entry to `sessions` array with date, duration, focus, completed items

**Step 5 — Update CLAUDE.md**

Show the diff, then update only the Stage cell in this company's CLAUDE.md pipeline-table row (e.g., "Round 1 DONE, 3.4/5 rubric-strict, awaiting next steps"). If the company is no longer in the pipeline table (closed), skip this step.

**Step 6 — Report:**

## DEBRIEF COMPLETE

**{Company} — {Interviewer}** | {Date} | Score: **{X}/5**

- **Saved:** `interview_prep/answers/{company}_{interviewer}_debrief_{date}.md`
- **Updated:** progress.json, CLAUDE.md, story_bank.json (after confirmation)
- **Transcript saved:** {path}

**Key lessons captured:**
1. {lesson 1}
2. {lesson 2}
3. {lesson 3}

**Next:** {confirmed next steps or "Awaiting response"}

**Step 6.5 — Career Learning Hooks:** run the four hooks in core §4 (lessons, takeaway, question bank, phantom). Propose, show, write after the user confirms. Then offer `/save-push`.

### `list` — Show All Debriefs

List all debrief files with dates, companies, interviewers, and scores.

### `<company> lessons` — Consolidated Lessons

Compile lessons from all debriefs for a company into one view.

**Steps:**
1. Find all debrief files for the company: `interview_prep/answers/{company}_*_debrief_*.md`
2. Extract "Key Lessons" section from each
3. Read progress.json for `patterns_to_fix` and `lessons_for_next_rounds`
4. Compile and deduplicate:

## {COMPANY} — LESSONS LEARNED

**From {N} interviews:**

**Round 1** ({interviewer}, {date}):
- {lesson}

**Round 2** ({interviewer}, {date}):
- {lesson}

**Patterns across rounds:**
- {recurring pattern}

**Action items for next round:**
- {specific thing to practice}
- {specific thing to prepare}

## Key Rules

- **Interactive first** — ask questions one at a time, don't dump a form
- **Conversational tone** — this is a debrief, not an interrogation
- **Honest assessment** — don't sugarcoat, but be constructive
- **Compare to prep** — always check what was prepped vs what happened
- **Update state with a diff and a yes** — progress.json and the CLAUDE.md Stage cell; `session_data.json` is a stale cache, leave it alone
- **Never edit an existing transcript or debrief**
- **Date format**: YYYY-MM-DD in filenames, human-readable in content
- **Filename format**: core §5 (`{company_key}_{interviewer_firstname}_debrief_{YYYY-MM-DD}.md`, never overwrite)
