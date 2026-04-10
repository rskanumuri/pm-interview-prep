# Post-Interview Debrief

Interactive guided debrief after each interview. Claude asks structured questions, the user answers conversationally, Claude formats everything into a structured debrief document.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

- Progress: `interview_prep/progress.json`
- Answers Directory: `interview_prep/answers/`
- CLAUDE.md: `CLAUDE.md` (project root)
- Companies Registry: `interview_prep/companies.json`
- Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md` (for pre-interview prep comparison)
- Session Data: `interview_prep/session_data.json`

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company> [interviewer]` — Start Interactive Debrief

Run an interactive guided debrief session. Ask questions one at a time, wait for answers, then compile.

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

After saving the debrief, offer: "Update master_story_repository.md with these angles?"

**Step 3 — Generate debrief document:**

Create `interview_prep/answers/{company}_{interviewer}_debrief_{date}.md` following this structure:

**File header:**
- `# {Company} — {Interviewer Name} Debrief`
- **Date:** {date}
- **Round:** {X of Y}
- **Duration:** ~{duration} ({used full time? or ended early?})
- **Format:** {format description}
- **Overall Score:** {self-score} / 5.0
- **Outcome:** {next steps or "Awaiting"}

**Score Breakdown** — table with columns: Dimension, Score, Notes

**Questions Asked** — numbered list with brief note on how each went

**What Landed** — bullet list of specific moments that worked

**What Didn't Land** — bullet list of specific moments that didn't work

**New Intel** — bullet list of role/team details, process/timeline, culture signals learned

**Key Lessons for Next Rounds** — numbered list of actionable lessons with specific fixes

**Prep vs Reality** — table with columns: Prepped For, What Actually Happened

**Prediction** — 1-2 sentence honest assessment of likelihood of advancing, based on signals

**Step 4 — Update progress.json**

**Step 5 — Update CLAUDE.md**

**Step 6 — Report**

### `list` — Show All Debriefs

List all debrief files with dates, companies, interviewers, and scores.

### `<company> lessons` — Consolidated Lessons

Compile lessons from all debriefs for a company into one view.

## Key Rules

- **Interactive first** — ask questions one at a time, don't dump a form
- **Conversational tone** — this is a debrief, not an interrogation
- **Honest assessment** — don't sugarcoat, but be constructive
- **Compare to prep** — always check what was prepped vs what happened
- **Update all state** — progress.json, CLAUDE.md, session_data.json must stay in sync
- **Date format**: YYYY-MM-DD in filenames, human-readable in content
- **Filename format**: `{company}_{interviewer_firstname}_debrief_{YYYY-MM-DD}.md` (lowercase, underscores)
