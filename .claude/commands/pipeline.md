# Pipeline Dashboard & Schedule Manager

Single source of truth for "where do I stand across all companies?" Reads CLAUDE.md schedule tables and progress.json to synthesize pipeline status.

## Data Files

- CLAUDE.md: `CLAUDE.md` (project root) — schedule tables, company context sections
- Progress: `interview_prep/progress.json` — company_readiness, scores, sessions
- Companies Registry: `interview_prep/companies.json`
- Applications: `interview_prep/applications.json` — top-of-funnel pipeline (if exists)
- Evaluations: `interview_prep/evaluations/*.json` — JD evaluations (if exist)
- Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- Insights: `interview_prep/insights/{company}.md`
- Rubrics: `interview_prep/rubrics/{company}.md`
- Debriefs: `interview_prep/answers/{company}_*_debrief_*.md`

## Commands

Parse `$ARGUMENTS` to determine the command:

### *(no args)* — Full Pipeline Dashboard

Read CLAUDE.md and progress.json, then display:

## PIPELINE DASHBOARD — {today's date}

---

### Next 48 Hours
### Active — By Stage
### Awaiting Response
### Closed
### Summary

### `update <company> <status>` — Update Company Status
### `schedule <company> <date> <time> <format>` — Add/Update Interview
### `advance <company> [details]` — Mark Advancing
### `drop <company> [reason]` — Mark Dropped/Rejected
### `prep-gaps` — Pre-Interview Prep Gap Analysis
### `full` — Full Funnel View (Top-of-Funnel + Interview Pipeline)
### `funnel` — Application Funnel Only

---

## Key Rules

- **CLAUDE.md is the source of truth** for interview schedules and company context
- **progress.json is the source of truth** for readiness percentages and scores
- **applications.json is the source of truth** for top-of-funnel — only read if the file exists
- **Always update both CLAUDE.md and progress.json** when making changes
- **Today's date**: use the current date for 48-hour window calculations
- **Don't move companies between sections** in CLAUDE.md without confirmation
- **Status text should be concise** — one line that captures current state
- **Pipeline stages** (in order): Discovered → Evaluated → Ready to Apply → Applied → Recruiter → HM/First Round → Mid-Process → Finals → Offer → Closed
