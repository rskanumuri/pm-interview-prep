---
description: "Build and track the daily prep plan from interview dates and prep gaps. Use for plan today or what is left."
---

# Battle Plan — Daily Prep Planning & Tracking

Auto-generates daily prep plan based on interview dates and prep gaps. Tracks time spent, shows completion percentage, rebalances when schedule changes.

## Data Files

- Battle Plan: `interview_prep/battle_plan.md` (the single ACTIVE plan; create it on first use if missing)
- Plan discovery: if `interview_prep/battle_plan.md` does not exist, look for the newest of `interview_prep/scripts/battle_plan_*.md` and `sources/general/battle_plan*.md` and say which you found. If more than one candidate looks active, list them and offer to archive the older ones (move only after the user agrees). Never merge or read several plans as one.
- Progress: `interview_prep/progress.json`
- CLAUDE.md: `CLAUDE.md` (pipeline stage and status; interview dates are in progress.json)
- Applications (if exists): `interview_prep/applications.json` — for top-of-funnel tasks
- All cheat sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- All answer files: `interview_prep/answers/{company}_*.md`

## Multi-Role File Keying

When reading/writing company-keyed files and rendering the daily plan, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Each role at a company is a distinct pipeline item; show them as separate lines (e.g., "Stripe / ML Foundations"), not collapsed into one company entry. Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### (no arguments) or `today` — What's the Plan?

**Step 1 — Read State**

Read battle_plan.md, progress.json, CLAUDE.md, and applications.json (if exists) to understand:
- What interviews are scheduled and when
- What prep has been completed (% per company)
- What time it is right now
- What was planned vs what got done
- **Top-of-funnel tasks** (from applications.json if it exists):
  - Roles with status `discovered` → need `/eval`
  - Roles with status `ready_to_apply` → need to submit application
  - Roles with status `applied` and applied_date 7+ days ago → need follow-up

**Step 2 — Calculate Urgency**

For each upcoming interview (parse `interview_dates` from progress.json; if a value is prose or unparseable, ask the user for the date instead of guessing):
```
hours = hours_until_interview            # skip entries where hours <= 0 (see below)
prep_gaps = count of open gap items for that company (company_readiness gaps / lessons_for_next_rounds not yet drilled); if no gap data exists, use (100 - readiness%) / 10
URGENCY = prep_gaps / max(hours, 1)
```

Sort by urgency descending. Interviews within 24 hours get highest priority. Entries with a date in the past are NOT urgent: list them as "past, debrief due" (offer `/debrief`) or "past, no debrief logged". If there are no upcoming interviews at all, say so plainly ("No scheduled interviews. Pipeline: {passive / none}") and show only top-of-funnel tasks, instead of inventing prep work.

**Step 3 — Generate Today's Plan**

## BATTLE PLAN — {Date}

---

### Next 48 Hours

- **{date time}** — **{Company}** ({Interviewer}, {Format})
  - Readiness: {X}% | Gaps: {list top 3 gaps}
  - **PRIORITY:** {HIGH/MEDIUM/LOW}

---

### Today's Schedule

- **{time block 1}:** {activity} — {company} — {what specifically}
- **{time block 2}:** {activity} — {company} — {what specifically}
- **{time block 3}:** {activity} — {company} — {what specifically}

---

### Completion vs Plan

- **{company 1}:** {X}% done (target: {Y}% by tonight)
- **{company 2}:** {X}% done (target: {Y}% by tonight)

**Step 4 — Save Plan**

Update `interview_prep/battle_plan.md` with today's plan. Archive the previous day's plan under a `## Archive` section in the same file. Keep the archive; do not delete older days (`history` depends on it). If the file grows past about 400 lines, ask the user before trimming and move the trimmed days to `sources/general/battle_plan_archive_{YYYY-MM}.md` rather than deleting them.

### `done <item>` — Mark Item Complete

Mark a prep item as done. Update battle_plan.md and progress.json.

### `add <company> <date> <time>` — Add Interview

Add a new interview to the schedule. Recalculate urgency and rebalance the plan.

### `drop <company>` — Remove Interview

Mark company as done/rejected/dropped. Remove from active plan. Archive prep.

### `rebalance` — Recalculate Everything

When interviews get added, cancelled, or rescheduled, recalculate the entire plan:
- What's remaining per company
- How much time is available
- What to prioritize

### `progress` — Show Overall Progress

## PREP PROGRESS — {Date}

| Company | Interview | Readiness | TMAY | Stories | Drills | Cheat Sheet |
|---------|-----------|-----------|------|---------|--------|-------------|

- **Total hours prepped:** {estimated from session count}
- **Prompts this sprint:** {from progress data}

### `history` — Show Past Battle Plans

Display archived daily plans with completion rates.

## Key Rules

- Only ONE active battle plan at a time. Archive old ones.
- Never allocate time to companies that are rejected/done
- Time blocks should be realistic — don't schedule 16 hours of prep
- When the user asks "what's left for today" or "how's my prep going", run this skill
- Always check the actual date/time before generating plans
- Saturday/Sunday are active prep days — don't skip weekends
