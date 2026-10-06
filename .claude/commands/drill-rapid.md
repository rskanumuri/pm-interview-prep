---
description: "Quick Q&A drill that pulls a question, shows the prepped answer, rates delivery, and saves progress."
---

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
- Session Data: `interview_prep/session_data.json` is a stale cache that may include another user's stories. Do NOT use it for the active user's prepped answers unless it demonstrably belongs to them.

## Multi-Role File Keying

When reading company-keyed files for context, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, use role-keyed artifacts, else fall back to `{company}_*`. Read-order on lookups: try role-keyed first, fall back to company-only.

## Active user guard

Check `progress.json` `active_user`. Draw stories only from `story_bank.json` and `sources/{active_user}/`. Never show stories that belong to another user (for example a shared `star_stories.json` that holds someone else's stories).

## Scoring (read this once)

Score each delivery /10 (the user's preference). Anchors, so the number means something:
- **9-10**: could be said in a real senior loop as-is; answer-first opener, year and context, canonical numbers with their units, ends cleanly.
- **7-8**: solid; one or two fixable misses (a number dropped, a loose opener).
- **5-6**: right content, weak delivery or missing numbers or no ownership clarity.
- **under 5**: wrong, rambling, or off-canon.
**Number cap**: if the user states a number that breaks `canonical_numbers` or a `canonical_provenance` ruling, the score is capped at 6 and the break is named.
**Do not inflate to keep momentum.** A 6 is a 6.
**Save both scales**: store `score_10` and `score_5 = score_10 / 2` so drills stay comparable with debriefs and `/pm-practice` (1-5). `weak` mode filters `score_10 < 7`.

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
3. Round scripts (if the company has them)
4. `story_bank.json` `scripted_versions` / `company_angles` for the matching story
5. Master story repository (match by LP/theme). If a story is matched ONLY by theme and not by this specific question, label it "Closest story by theme, not a prepped answer".

Do not use `session_data.json` for the user.

**Canon check BEFORE displaying (mandatory).** Scan the prepped answer text against `story_bank.json` `canonical_numbers`, `canonical_provenance` and `purged_stories` (the `/story-check` rules). If it contains a stale number, a provenance violation (a number said without its unit or denominator, a metric attributed to the wrong product, an outcome stated stronger than its basis), or a purged story, show a warning block ABOVE the answer: "DRIFT IN PREP: {line} -> {canonical wording}". Never present drifted text under "Internalize it". If a number is marked OPEN in provenance, print "do not quote: {number}" next to it.

Display:

## Q: {Full question text}

**Company:** {company} | **LP/Theme:** {if applicable}

---

**PREPPED ANSWER:**

{Full answer text -- opener + key details}

---

*Read it. Internalize it. Now deliver it in your words.*

If no prepped answer exists: "No prepped answer found. Want me to build one?" (A cold attempt happens only if the user explicitly asks for it. Otherwise always show a prepped answer first.)

**Step 3 — Rate the User's Delivery**

After the user delivers, provide quick scoring:

**SCORE: {X}/10** (anchors and number cap above)

- (+) {what landed}
- (+) {what landed}
- (-) {what missed or diverged from prep}
- (-) {what missed}

**Delta from prep:** {what the user changed vs the prepped answer -- good or bad}

Feedback is a quick read between reps: lead with the score, then only the points that would change the next delivery.

**Step 4 — Quick Save**

If the user's delivery was notably better than the prepped answer, offer to update the answer file.

Then ask: "Next question?" and repeat.

### `<company> q<N>` — Specific Question

Drill a specific question by ID (e.g., `/drill-rapid {company} q15`).

### `<company> weak` — Drill Weak Areas Only

Pull only from questions scored below 7/10 or flagged in progress.json.

### `<company> lp <leadership_principle>` — Drill by LP

Drill questions mapped to a specific LP (e.g., `/drill-rapid amazon lp customer-obsession`).

### `<company> speed` — Speed Round

5 questions back-to-back. Show prepped answer, user delivers opener only (30 seconds), quick 1-line score, immediately move to next. At the end, show summary:

**SPEED ROUND — {Company}**

- **Q1:** {score}/10 -- {1-word verdict}
- **Q2:** {score}/10 -- {1-word verdict}
- **Q3:** {score}/10 -- {1-word verdict}
- **Q4:** {score}/10 -- {1-word verdict}
- **Q5:** {score}/10 -- {1-word verdict}
- **AVG:** {avg}/10
(Scores are computed from the anchors, never copied from an example.)

### `gaps` — Fill Story-Bank Coverage Gaps (elicit real stories, never invent)

The story bank has known coverage holes (audit, Oct 2026): people management / hiring / coaching an underperformer, a quantified failure with real damage, disagree-and-commit, killing a project or feature against stakeholder anger, and a conflict with a peer PM or engineering that the user did NOT fully win. One employer or project may also be over-represented across the bank. This mode builds real stories for those gaps from what the user actually did.

1. Read `story_bank.json` `stories[].themes` and `question_types`; list which of the five gap types above have 0 or 1 stories, plus any theme tagged on fewer than 2 stories.
2. Pick one gap type (the user chooses, or start with the emptiest). Ask ONE question at a time to elicit a real story: when, what was the situation, what did YOU decide or do (not the team), what was the stake, what happened (a number only if the user supplies one and knows its basis), what would you do differently. Ask for the unit and the measurement basis of any number.
3. NEVER invent details, names, numbers or outcomes. If the user cannot recall a number, write "no number". If the user has no real story for a gap, record "no story; bridge only" and stop. A bridge to adjacent experience must be labeled as a bridge.
4. Draft a Layer-1 opener (answer first, year and context) and Layer-2 follow-ups from only the facts the user gave. Show it. The user corrects it.
5. Run the canon check (numbers, provenance, purged stories) on the draft. Flag anything that conflicts.
6. Rate the user's delivery of the draft with the normal /10 scoring. Only after the user confirms the story is accurate, offer to add it to `story_bank.json` (new entry with `status: "needs_work"`, themes, question_types, no `company_angles` until mapped). Do not write without his yes.

## Key Rules

- **Show answer first, ALWAYS** — the user learns by reading then delivering. Never quiz cold without showing prep.
- **Keep feedback short.** Rapid drill, not deep coaching.
- **Score on /10**
- **Don't repeat questions** already drilled in this session
- **Track progress** — update progress.json (this company's drill entries only; show the entry before writing): `{date, company, question_id, score_10, score_5, note}`
- **"Next?"** — always offer to continue. Keep momentum.
- **No fabrication** — if there's no prepped answer, say so. Don't make one up and present it as prepped.
