---
description: "Single-shot debrief from a pasted interview transcript or notes, with scores, key moments, and a saved file."
---

# Debrief Live — Instant Transcript Debrief

Paste a transcript or conversation notes → get instant performance rating, structured debrief, and saved file. Unlike `/debrief` (interactive Q&A), this is a single-shot: paste content, get analysis.

**Read `interview_prep/reference/debrief_core.md` first.** It is the shared rulebook for transcripts, scoring, story-bank write-back, state writes, and career-learning hooks. Where it conflicts with this file, it wins.

## Data Files

- Progress: `interview_prep/progress.json`
- Answers Directory: `interview_prep/answers/`
- Company Insights: `interview_prep/insights/{company}.md`
- Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- CLAUDE.md: `CLAUDE.md` (company context)
- Rubrics: `interview_prep/rubrics/{company}.md`
- Master Rubric: `interview_prep/rubric.md`

## Multi-Role File Keying

When reading/writing company-keyed files, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". This command accepts an optional `<role>` arg; when provided, debriefs save as `{company}_{role_slug}_{interviewer}_debrief_*.md`, else fall back to `{company}_*` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<company> [interviewer]` — Instant Debrief from Pasted Content

Expects pasted transcript/notes in the same message or immediately following.

**Step 1 — Detect Content**

The user will paste one or more of:
- Full interview transcript (from Granola, Otter, or manual notes)
- Bullet-point notes of what happened
- Interviewer feedback (recruiter relay or direct)
- Self-assessment

If no content is pasted, first check `sources/<company>/` for a saved transcript, then Granola (core §0). Only if both are empty, ask: "Paste your transcript or notes and I'll analyze."

**Step 1.5 — Save the transcript verbatim (core §0).** Write the full pasted text to `sources/<company>/<interviewer>_<type>_transcript_<date>.md` with a `**Source:**` line BEFORE any analysis. No summaries.

**Step 2 — Read Context**

Read in parallel:
- Company cheat sheet (what was prepped)
- Company rubric (scoring dimensions)
- Progress.json (prior round data)
- CLAUDE.md company section

**Step 3 — Analyze and Rate**

From the pasted content, extract and score:

Score per core §1: company rubric dimensions with weights, unattempted rows scored as unattempted, penalties named, Overall = rubric-strict (not the self-score), a quote or moment cited for every score. The generic six dimensions (Domain Knowledge, Strategic Thinking, Quantitative Rigor, Communication Precision, Conviction & Presence, Story Quality) are a labeled last-resort fallback only.

**Step 4 — Extract Key Moments**

From the transcript, identify:
- **Landed**: Moments where interviewer engaged, asked follow-ups, said positive things
- **Missed**: Moments where the user stumbled, got redirected, missed an opportunity
- **Intel**: New information about role, team, process, next steps
- **Patterns**: Recurring issues across this and previous rounds (check debriefs)

**Step 4.5 — Extract Story Angles**

From the transcript, identify which stories from `interview_prep/scripts/master_story_repository.md` were used:
- Which stories were told (match by name from master repo)
- What angle/frame was applied for this company
- Whether it landed (from Step 4 evidence)
- Any new angle discovered

Add a "Story Angles Used" section to the debrief output.

After saving the debrief, write the angles to `story_bank.json` per core §2 (canonical). Offer the mirror edit to `master_story_repository.md`; never reset a prior `tested`/`score`.

**Step 5 — Generate Debrief Document**

Create `interview_prep/answers/{company}_{interviewer}_debrief_{YYYY-MM-DD}.md`:

**File header:**
- `# {Company} — {Interviewer} Debrief (Live)`
- **Date:** {date}
- **Source:** {transcript/notes/feedback}
- **Overall Score:** {rubric-strict}/5 | Self-score: {self-score or n/a}
- **Transcript:** {saved path}

**Score Breakdown** — table with columns: Dimension, Weight, Score (1-5), Key Evidence. Rows from the company rubric (core §1). List penalties applied.

**What Landed** — bullet list of moments with quotes if available

**What Missed** — bullet list of moments with what should have been said

**New Intel** — bullet list of role/team/process details and next steps

**Fixes for Next Round** — numbered list of specific actionable fixes

**Prediction** — 1-2 sentence honest assessment of advancing likelihood

**Step 6 — Update State**

Show the diff first (core §3), then after confirmation:
1. Update progress.json with this company's round data only
2. Update only the Stage cell in this company's CLAUDE.md pipeline-table row (skip if the company is closed)
3. Write story angles to `story_bank.json` (core §2)

**Step 6.5 — Career Learning Hooks:** run the four hooks in core §4 (lessons, takeaway, question bank, phantom). This step was missing from this command before.

**Step 7 — Report**

## LIVE DEBRIEF — {Company} ({Interviewer})

**Score:** {X}/5

- **Landed:** {top moment}
- **Missed:** {top miss}
- **Fix:** {top fix}

**Saved** -> `interview_prep/answers/{filename}`
**Transcript** -> `sources/<company>/{transcript filename}`

## Key Rules

- Score on the company rubric (1-5); use the master rubric if none exists; Overall is rubric-strict, never the self-score
- Be honest — don't sugarcoat. The user catches BS.
- Always compare to what was prepped (cheat sheet vs what actually happened)
- Extract DIRECT QUOTES from transcript when available
- If the user pastes feedback from recruiter/interviewer, weight that heavily — it's ground truth
- If content is too short to score all dimensions, score what's available and mark others "N/A"
- After saving, OFFER `/save-push`; do not auto-commit or push
- Never edit an existing transcript or debrief
