# Auto-Pipe — One-Shot JD Processing Pipeline

Paste a JD URL or text and get everything in one shot: evaluation, tailored CV, pipeline entry, and next steps. This is the "paste and go" workflow for PM interview prep.

## Data Files

Same as `/eval` + `/cv-gen` combined. This skill orchestrates both.

### Read
- All files from `/eval` (resume, story bank, CLAUDE.md, progress.json, applications.json)
- All files from `/cv-gen` (resume, template, eval data)

### Write
- Evaluation: `interview_prep/evaluations/{company}_{role_slug}_eval.json`
- Applications: `interview_prep/applications.json`
- CV HTML: `output/cv/{company}_{active_user}_{date}.html`
- CV PDF: `output/cv/{company}_{active_user}_{date}.pdf`
- Progress: `interview_prep/progress.json` (if company already exists)

## Commands

Parse `$ARGUMENTS`:

### `<url-or-jd-text>` — Full Pipeline

**Steps:**

1. **Obtain JD:**
   - If URL: fetch via WebFetch
   - If text: use directly
   - If fetch fails: ask user to paste JD text

2. **Run /eval logic (6-block evaluation):**
   - Execute full 6-block A-F evaluation per eval.md
   - Save evaluation JSON
   - Add to applications.json

3. **Decision gate:**
   - If overall score >= 3.0: proceed to CV generation
   - If overall score < 3.0: stop here. Display eval results and recommend skipping.
     Show: "Score {X}/5 — below threshold. Skip this role? Or run `/cv-gen {company}` to generate CV anyway."

4. **Run /cv-gen logic (tailored resume):**
   - Generate ATS-optimized HTML
   - Attempt PDF generation via Playwright
   - If PDF fails, continue with HTML only (not a blocker)

5. **Register in pipeline:**
   - Add/update `applications.json` entry:
     - status: `ready_to_apply` if score >= 3.0
     - eval_score, eval_file, cv_file populated
   - If company not in `companies.json`, offer to register

6. **Display combined results:**

## AUTO-PIPE COMPLETE — {COMPANY} — {Role Title}

---

### Evaluation

**Verdict:** {STRONG FIT / FIT WITH GAPS / STRETCH} ({X.X}/5.0)
**Archetypes:** {matched} ({N}/{total} overlap)
**Block Grades:** A:{grade} B:{grade} C:{grade} D:{grade} E:{grade} F:{grade}

**Top matches:**
- {requirement} — {score}/5 — {evidence}
- {requirement} — {score}/5 — {evidence}
- {requirement} — {score}/5 — {evidence}

**Gaps:**
- {gap} — {severity}

---

### Tailored CV

- **PDF:** `output/cv/{company}_{active_user}_{date}.pdf`
- **HTML:** `output/cv/{company}_{active_user}_{date}.html`
- **Keywords injected:** {N}

---

### Pipeline Status

- **Status:** ready_to_apply
- **Eval:** `interview_prep/evaluations/{company}_{slug}_eval.json`
- **CV:** `output/cv/{company}_{active_user}_{date}.pdf`

---

### Next Steps

- Apply with the tailored CV
- Run `/company-prep {company}` to build full interview prep
- Run `/fit-check {company}` for deep gap analysis + bridge scripts

7. Offer: "Run `/company-prep {company}` to build interview prep scaffold?"
8. Offer: "Run `/save-push` to save everything?"

---

### `<url-or-jd-text> --eval-only` — Evaluate Only

Run only the evaluation step (no CV generation). Same as `/eval <url>` but called through auto-pipe for consistency.

---

## Key Rules

- **This is a convenience orchestrator.** It calls the same logic as `/eval` and `/cv-gen` — no separate evaluation or CV generation logic.
- **Score threshold is 3.0/5.** Below that, don't waste time on CV generation unless user insists.
- **PDF failure is not a blocker.** If Playwright isn't installed, the HTML is still generated and useful.
- **Always offer /company-prep** for scores >= 3.0 — this is the natural next step from top-of-funnel to interview prep.
- **Don't auto-register companies** in companies.json without asking. The user may not want to prep for every role they evaluate.

## Integration with Other Skills

### Orchestrates
- `/eval` logic — 6-block JD evaluation
- `/cv-gen` logic — ATS resume generation

### Feeds Into
- `/company-prep` — natural next step for roles worth pursuing
- `/fit-check` — deep gap analysis
- `/pipeline full` — role appears in top-of-funnel view

### Cross-References in Output
- Score >= 4.0: "→ /company-prep {company}"
- Score >= 3.0: "→ /fit-check {company} gaps"
- Always: "→ /save-push"
