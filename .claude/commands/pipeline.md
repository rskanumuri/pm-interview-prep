---
description: "Pipeline dashboard and status updates across companies. Use for show pipeline or interview dashboard."
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

When reading company-keyed files and rendering the pipeline, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". For display, show each `{company}_{role_slug}` as its own row with the role name visible (e.g., "Stripe / ML Foundations" and "Stripe / Payments" as separate lines), not collapsed into one company entry. When reading companies.json / progress.json, treat role-keyed entries as distinct pipeline items.



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

Closing a company changes shared state and triggers learning steps, so it needs a confirmation. Never remove a row silently.

1. Read progress.json, CLAUDE.md, `interview_prep/reference/closed_pipeline.md`, and `applications.json` (if the company is there).
2. Ask which outcome it is (rejected / withdrew / no decision) and the date if the user knows it; never invent a date ("date not recorded" is fine).
3. Show the exact before/after for each change and wait for the user's yes:
   - progress.json `company_readiness` status → "DROPPED — {reason}" or "REJECTED — {reason}" (that company's keys only)
   - CLAUDE.md: move the row out of the Accepted/Passive table (Stage cell text is not rewritten beyond the move) and update the Closed Companies line and counts
   - `closed_pipeline.md`: add the row to the right table
   - `applications.json`: set status `closed` with the reason (never overwrite `applied`/`interviewing` history fields)
4. After confirmation, run the closing hooks (CLAUDE.md "Career Learning Hooks"), propose-only:
   - if rejected: read the company's debriefs and `career_takeaways.md`, PROPOSE one career takeaway
   - if `{company_key}_phantom.md` exists: offer a short post-mortem appended to it
   - offer (do not do) moving the company's loose files into `sources/{company}/`
5. Confirm: **{Company} — Closed ({outcome})** | Updated: {files}

### `prep-gaps` — Pre-Interview Prep Gap Analysis
### `full` — Full Funnel View (Top-of-Funnel + Interview Pipeline)
### `funnel` — Application Funnel Only

---

## Key Rules

- **progress.json is the source of truth** for interview dates; CLAUDE.md's Active Pipeline section holds stage and status
- **progress.json is the source of truth** for readiness percentages and scores
- **applications.json is the source of truth** for top-of-funnel — only read if the file exists
- **Always update both CLAUDE.md and progress.json** when making changes
- **Today's date**: use the current date for 48-hour window calculations
- **Don't move companies between sections** in CLAUDE.md without confirmation
- **Status text should be concise** — one line that captures current state
- **Pipeline stages** (in order): Discovered → Evaluated → Ready to Apply → Applied → Recruiter → HM/First Round → Mid-Process → Finals → Offer → Closed
