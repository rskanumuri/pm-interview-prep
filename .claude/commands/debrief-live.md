# Debrief Live — Instant Transcript Debrief

Paste a transcript or conversation notes → get instant performance rating, structured debrief, and saved file. Unlike `/debrief` (interactive Q&A), this is a single-shot: paste content, get analysis.

## Data Files

- Progress: `interview_prep/progress.json`
- Answers Directory: `interview_prep/answers/`
- Company Insights: `interview_prep/insights/{company}.md`
- Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- CLAUDE.md: `CLAUDE.md` (company context)
- Rubrics: `interview_prep/rubrics/{company}.md`
- Master Rubric: `interview_prep/rubric.md`

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company> [interviewer]` — Instant Debrief from Pasted Content

Expects pasted transcript/notes in the same message or immediately following.

**Step 1 — Detect Content**

The user will paste one or more of:
- Full interview transcript (from Granola, Otter, or manual notes)
- Bullet-point notes of what happened
- Interviewer feedback (recruiter relay or direct)
- Self-assessment

If no content is pasted, ask: "Paste your transcript or notes and I'll analyze."

**Step 2 — Read Context**

Read in parallel:
- Company cheat sheet (what was prepped)
- Company rubric (scoring dimensions)
- Progress.json (prior round data)
- CLAUDE.md company section

**Step 3 — Analyze and Rate**

From the pasted content, extract and score:

| Dimension | Score /10 | Evidence |
|-----------|-----------|----------|
| Domain Knowledge | X | {specific moment from transcript} |
| Strategic Thinking | X | {evidence} |
| Quantitative Rigor | X | {did numbers land? which ones?} |
| Communication Precision | X | {redirects, clarity, answer-first} |
| Conviction & Presence | X | {energy, closing, confidence signals} |
| Story Quality | X | {STAR structure, attribution, depth} |
| **Overall** | **X** | **{1-sentence verdict}** |

Score on /10 scale.

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

After saving the debrief, offer: "Update master_story_repository.md with these angles?"

**Step 5 — Generate Debrief Document**

Create `interview_prep/answers/{company}_{interviewer}_debrief_{YYYY-MM-DD}.md`

**Step 6 — Update State**

1. Update progress.json with round data
2. Update CLAUDE.md interview schedule status

**Step 7 — Report**

## LIVE DEBRIEF — {Company} ({Interviewer})

**Score:** {X}/10

- **Landed:** {top moment}
- **Missed:** {top miss}
- **Fix:** {top fix}

**Saved** -> `interview_prep/answers/{filename}`

## Key Rules

- Score on /10 scale (not /5)
- Be honest — don't sugarcoat
- Always compare to what was prepped (cheat sheet vs what actually happened)
- Extract DIRECT QUOTES from transcript when available
- If the user pastes feedback from recruiter/interviewer, weight that heavily — it's ground truth
- If content is too short to score all dimensions, score what's available and mark others "N/A"
- After saving, offer to run `/save-push`
