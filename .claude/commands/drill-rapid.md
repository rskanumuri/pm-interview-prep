# Drill Rapid — Quick Q&A Without Full Mock

Lightweight practice: pull a question, show the prepped answer first, accept the user's attempt, rate, save. Faster than `/pm-practice` — no full mock simulation, no 18-minute grilling.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (check `scripted_versions` for prepped answers, `company_angles` for company-specific framing. After the user delivers, compare framing against stored `angles[]` — if new angle detected, prompt to add it.)
- Questions: `interview_prep/questions.json`
- Company Scripts: `interview_prep/scripts/{company}_interview_questions.md` or `{company}_cheat_sheet.md`
- Answer Files: `interview_prep/answers/{company}_*.md`
- Round Scripts: `sources/{company}/` (company-specific round scripts, e.g., round1.md through round4.md)
- Master Story Repository: `interview_prep/scripts/master_story_repository.md`
- Progress: `interview_prep/progress.json`
- Session Data: `interview_prep/session_data.json`

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company>` — Random Question Drill

**Step 1 — Pick a Question**

Pull a random question from the company's question bank. Prioritize:
1. Questions the user hasn't practiced (check progress.json)
2. Questions flagged for review
3. Questions in weak LP areas

**Step 2 — Show Prepped Answer First**

Standing instruction: "First time - always show the answer."

Search for the prepped answer in this order:
1. Company interview questions file (`scripts/{company}_interview_questions.md`)
2. Company cheat sheet answer section
3. Round scripts (in `sources/{company}/`)
4. Master story repository (match by LP/theme)
5. Session data consolidated answers

Display:

## Q: {Full question text}

**Company:** {company} | **LP/Theme:** {if applicable}

---

**PREPPED ANSWER:**

{Full answer text -- opener + key details}

---

*Read it. Internalize it. Now deliver it in your words.*

If no prepped answer exists: "No prepped answer found. Want me to build one, or try cold?"

**Step 3 — Rate the User's Delivery**

After the user delivers, provide quick scoring:

**SCORE: {X}/10**

- (+) {what landed}
- (+) {what landed}
- (-) {what missed or diverged from prep}
- (-) {what missed}

**Delta from prep:** {what the user changed vs the prepped answer -- good or bad}

Keep feedback to 5 lines max. This is rapid drill, not deep analysis.

**Step 4 — Quick Save**

If the user's delivery was notably better than the prepped answer, offer to update the answer file.

Then ask: "Next question?" and repeat.

### `<company> q<N>` — Specific Question

Drill a specific question by ID (e.g., `/drill-rapid netapp q15`).

### `<company> weak` — Drill Weak Areas Only

Pull only from questions scored below 7/10 or flagged in progress.json.

### `<company> lp <leadership_principle>` — Drill by LP

Drill questions mapped to a specific LP (e.g., `/drill-rapid amazon lp customer-obsession`).

### `<company> speed` — Speed Round

5 questions back-to-back. Show prepped answer, user delivers opener only (30 seconds), quick 1-line score, immediately move to next. At the end, show summary:

**SPEED ROUND — {Company}**

- **Q1:** {7}/10 -- {1-word verdict}
- **Q2:** {8}/10 -- {1-word verdict}
- **Q3:** {5}/10 -- {1-word verdict}
- **Q4:** {9}/10 -- {1-word verdict}
- **Q5:** {6}/10 -- {1-word verdict}
- **AVG:** {7.0}/10

## Key Rules

- **Show answer first, ALWAYS** — the user learns by reading then delivering. Never quiz cold without showing prep.
- **Keep feedback SHORT** — this is rapid drill, not deep coaching. Max 5 lines of feedback.
- **Score on /10**
- **Don't repeat questions** already drilled in this session
- **Track progress** — update progress.json with drilled questions and scores
- **"Next?"** — always offer to continue. Keep momentum.
- **No fabrication** — if there's no prepped answer, say so. Don't make one up and present it as prepped.
