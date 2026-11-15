---
description: "Pipeline dashboard and status updates across companies. Use for show pipeline or interview dashboard."
argument-hint: "[update | schedule | advance | drop] <company> ... | prep-gaps | full | funnel"
---

# Pipeline Dashboard & Schedule Manager

Single source of truth for "where do I stand across all companies?" Reads CLAUDE.md's Active Pipeline section (stage, status) and progress.json (`interview_dates`, readiness) to synthesize pipeline status.

## Data Files

- CLAUDE.md: `CLAUDE.md` (project root) — Active Pipeline section (stage, status, files)
- Progress: `interview_prep/progress.json` — company_readiness, scores, sessions
- Companies Registry: `interview_prep/companies.json`
- Applications: `interview_prep/applications.json` — top-of-funnel pipeline (if exists)
- Evaluations: `interview_prep/evaluations/*.json` — JD evaluations (if exist)
- Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- Insights: `interview_prep/insights/{company}.md`
- Rubrics: `interview_prep/rubrics/{company}.md`
- Debriefs: `interview_prep/answers/{company}_*_debrief_*.md`

## Multi-Role File Keying

Rule: `interview_prep/reference/skills_core.md` §3 (how `{company_key}` is formed, role-keyed lookup first, where closed-company files live). Show each `{company_key}` as its own row with the role name visible (for example "Stripe / ML Foundations" and "Stripe / Payments"), and treat role-keyed entries in `companies.json` and `progress.json` as distinct pipeline items.

## Commands

Parse `$ARGUMENTS` to determine the command:

### *(no args)* — Full Pipeline Dashboard

First run the clock and schedule check (`interview_prep/reference/skills_core.md` §1) for every company in an active table. If an active company has no entry in `interview_dates`, list it under "Next 48 Hours" as "date not recorded" instead of leaving it out.

Read CLAUDE.md and progress.json, then display:

## PIPELINE DASHBOARD: {today's date}

---

### Next 48 Hours

- **{date} {time}**: **{Company}**, {format} with {interviewer}
  - Prep: {ready%} | Cheat sheet: Yes/No | Gaps: {list}
- **{date} {time}**: **{Company}**, {format}
  - Prep: {ready%} | Cheat sheet: Yes/No | Gaps: {list}

---

### Active — By Stage

**Recruiter Screen:**
- {Company}: {status detail}

**HM / First Round:**
- {Company}: {status detail}

**Mid-Process (Round 2-3):**
- {Company}: {status detail}

**Finals / Offer:**
- {Company}: {status detail}

---

### Awaiting Response

- {Company}: {what you're waiting for} (since {date})

---

### Closed

- {Company}: {outcome} ({date})

---

### Summary

- **Active:** {N} | **Awaiting:** {N} | **Closed:** {N}
- **Interviews this week:** {N}
- **Next interview:** {Company} on {date} at {time}

**How to categorize companies:**
- Read CLAUDE.md's Active Pipeline section for stage and status; read `interview_dates` from progress.json
- Read progress.json company_readiness for each company
- Categorize by the entry's `stage` and `outcome` keys when present. For older entries without them, fall back to the status text:
  - "DONE" + "advancing" → Mid-Process
  - "DONE" + "awaiting" → Awaiting Response
  - "closed", "rejected", "dropped" or "withdrew" (any letter case), or an `outcome` key on the entry → Closed
  - "Prep in progress" or "Prep needed" → Active upcoming
  - "Recruiter" → Early Pipeline
- For Next 48 Hours: filter to interviews with dates within 48 hours of today

### `update <company> <status>` — Update Company Status

Free-text status update for a company.

1. Read progress.json
2. Update `company_readiness.{company}.status` with the new status text, and set the structured `stage` key to one of: `prep`, `recruiter`, `technical`, `hm`, `loop`, `final`, `offer`, `awaiting` (keep the previous stage in `awaiting_after` when waiting on a response). Views sort on `stage` and `outcome` first and fall back to matching words in the status text only for older entries that have neither
3. Update the Stage cell in this company's CLAUDE.md pipeline-table row to match
4. Write both files
5. Confirm the update

Example: `/pipeline update {company} "Recruiter screen passed. Next: HM fit call."`

### `schedule <company> <date> <time> <format>` — Add/Update Interview

Add or update an interview on the calendar. Use this for a reschedule too: the moment a recruiter moves a call, the old value in `interview_dates` is wrong and every date-driven view is wrong with it. Value format: `interview_prep/reference/skills_core.md` §1.

1. Read progress.json and CLAUDE.md
2. Update `interview_dates.{company}` in progress.json
3. Update the Stage cell in CLAUDE.md's pipeline-table row if the stage changed (dates live only in progress.json)
4. If company has a cheat sheet, update the date/type header
5. Write all changed files
6. Confirm: **Scheduled: {Company} -- {format}** | Date: {date} at {time} | Updated: progress.json, CLAUDE.md

### `advance <company> [details]` — Mark Advancing

Mark a company as advancing to the next round.

1. Read progress.json and CLAUDE.md
2. Update company_readiness:
   - Increment round info
   - Update status to "Advancing, {details}"
   - Update percent as appropriate
3. Move the company's row within CLAUDE.md's Active Pipeline section if needed
4. Write both files
5. Confirm: **{Company} -- Advancing** | {details} | Updated: progress.json, CLAUDE.md

### `drop <company> [reason]` — Mark Dropped/Rejected

Closing a company changes shared state and triggers learning steps, so it needs a confirmation. Never remove a row silently.

This is the ONE close-out path. `/battle-plan drop` and the CLAUDE.md archive hooks point here. Trigger phrases: "got the reject", "they passed", "I withdrew", "close out {company}".

1. **Read:** progress.json, CLAUDE.md, `interview_prep/reference/closed_pipeline.md`, `applications.json` (if the company is there), and the company's debriefs.
2. **Outcome and date.** Ask which outcome it is (rejected / withdrew / no decision). For the date and any stated reason: if mail tools are connected, find the message and take them from it; otherwise ask. Never invent a date or a reason ("date not recorded", "no reason recorded" are fine).
3. **Find every file for this role.** Glob `interview_prep/**/*{company_key}*` (scripts, insights, rubrics, evaluations, answers, research) and list `sources/{company}/`. Files for a different role at the same company are not touched.
4. **Show the full plan as one before/after list and wait for the user's yes:**
   - `progress.json` `company_readiness.{company_key}`: status → "CLOSED: {outcome} {date}. {one-line reason or 'no reason recorded'}. Files archived to sources/{company}/." Add `"outcome"` and `"closed_date"` keys. Remove `interview_dates.{company_key}`. That company's keys only.
   - `applications.json`: status → `rejected`, `withdrawn`, or `closed` (no decision). Append the outcome to `notes`. Update any stored file path (for example `eval_file`) to its new location. Never overwrite `applied_date` or other history fields.
   - `CLAUDE.md`: remove the row from the Active Pipeline table (write "None active." if the table becomes empty), update the "Most recent" sentence and the counts in the Closed Companies line, and any "one active" wording elsewhere in the file.
   - `closed_pipeline.md`: add the row to the right table, with stage reached, date, and file pointer.
   - **File moves:** `git mv` each file from step 3 into `sources/{company}/`, keeping the role-keyed name (add `_insights` or `_rubric` when the bare name would be ambiguous in one folder). Leave `companies.json`, the why-scripts entry and story-bank angles in place; companies resurface.
   - **Outcome note:** new file `sources/{company}/outcome_{YYYY-MM-DD}.md` with a `**Source:**` line, the outcome, the likely cause marked as inference, and what carries forward. Debriefs and transcripts are never edited.
5. **After the yes,** apply everything per `interview_prep/reference/skills_core.md` §2 (text edits, safe to re-run, validate JSON).
6. **Closing hooks, propose-only** (CLAUDE.md "Career Learning Hooks"):
   - if rejected: PROPOSE one career takeaway, unless the last debrief already produced one for this round
   - if `{company_key}_phantom.md` exists: offer a short post-mortem appended to it
   - offer `/story-bank refresh` so the company section shows final tellings
   - if an unsent draft to this company exists in mail, mention it
7. Confirm: **{Company}: Closed ({outcome})** | Updated: {files} | Moved: {N} files. Then offer `/save-push`.

### `prep-gaps` — Pre-Interview Prep Gap Analysis

For interviews in the next 48 hours, show what prep exists vs what's missing.

1. Read `interview_dates` in progress.json to find interviews in the next 48 hours
2. For each upcoming interview, check:
   - Cheat sheet exists? Has TMAY, Story Map, Q&A?
   - Insights file has content?
   - Rubric has dimensions?
   - Why script exists?
   - Any debriefs from prior rounds?
   - Practice questions attempted?
   - Debrief lessons from prior rounds?
3. Display:

## PREP GAPS: Next 48 Hours

---

### {Company}: {date} {time}, {format}

- Cheat sheet (TMAY, 5 Q&A, Story Map) — **Yes**
- Insights (mission, values, 12 tips) — **Yes**
- Rubric (3 dimensions) — **Yes**
- Why script (3 beats) — **Yes**
- Verbal reps logged — **No**
- Prior round lessons: "{lesson from the last debrief}"

**Recommended:**
- Run `/prep-check {company}` for readiness briefing
- Do 2 verbal reps on TMAY + Why {Company}
- Review prior round lessons

### `full` — Full Funnel View (Top-of-Funnel + Interview Pipeline)

If `interview_prep/applications.json` exists, show the complete funnel from discovery through interviews.

**Steps:**
1. Read `interview_prep/applications.json`
2. Read `interview_prep/evaluations/*.json` for eval scores
3. Group applications by status
4. Display top-of-funnel above the standard pipeline view:

## FULL PIPELINE: TOP TO BOTTOM

---

### Top-of-Funnel

**Discovered ({N}):**
- {Company}: {Role}, discovered {date}, `/eval {url}`

**Evaluated ({N}):**
- {Company}: {Role}, {score}/5 {verdict}, `/company-prep {company}`

**Ready to Apply ({N}):**
- {Company}: {Role}, {score}/5, CV: Yes/No, Apply now

{... then standard ACTIVE, By Stage, AWAITING, CLOSED sections ...}

---

### Funnel Metrics

- **Discovered:** {N} → **Evaluated:** {N} → **Applied:** {N} → **Interviewing:** {N}
- **Conversion:** {eval to apply %} | {apply to interview %}

If `applications.json` does not exist, show: "Top-of-funnel not set up. Run `/scan` to discover roles."

---

### `funnel` — Application Funnel Only

Show only the top-of-funnel view from `applications.json` (no interview pipeline).

Same as the top-of-funnel section from `full`, but standalone. Quick view for "what do I need to evaluate or apply to?"

---

## Key Rules

- **progress.json is the source of truth** for interview dates; CLAUDE.md's Active Pipeline section holds stage and status
- **progress.json is the source of truth** for readiness percentages and scores
- **applications.json is the source of truth** for top-of-funnel (discovered, evaluated, ready_to_apply) — only read if the file exists
- **Always update both CLAUDE.md and progress.json** when making changes to interview pipeline
- **Today's date**: use the current date for 48-hour window calculations
- **Don't move companies between sections** in CLAUDE.md without confirmation
- **Status text should be concise** — one line that captures current state
- **Pipeline stages** (in order): Discovered → Evaluated → Ready to Apply → Applied → Recruiter → HM/First Round → Mid-Process → Finals → Offer → Closed
