---
description: "Paste a JD URL or text to evaluate it, tailor a CV, and register it in the pipeline in one pass."
---

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
- CV HTML: `output/cv/{company_key}_resume_{date}.html`
- CV PDF: `output/cv/{company_key}_resume_{date}.pdf`
- Progress: `interview_prep/progress.json` (if company already exists)

## Multi-Role File Keying

Since this command chains `/eval`, `/company-prep`, and `/fit-check`, it must propagate the `<role>` arg through all three. Follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, every downstream artifact is role-keyed. When omitted, all three chained commands use legacy `{company}_*` naming.



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

3. **Decision gate (all must pass before CV generation):**
   - Title gate = PASS (no "project manager" / "program manager"), from the eval's `gates.title`
   - H1B gate = SPONSORS (from `gates.h1b`). UNKNOWN: stop and ask the user to confirm transfer sponsorship first. BLOCKED: stop.
   - Unrounded overall score >= 3.0
   - If any check fails: stop here. Display eval results and the failed gate(s).
     Show: "Gate failed: {title / h1b / score X}. Skip this role? Or say 'override' and why to generate a CV anyway." An override is recorded (`gate_override: true`) and never silent.

4. **Run /cv-gen logic (tailored resume):**
   - Generate ATS-optimized HTML
   - Attempt PDF generation via Playwright
   - If PDF fails, continue with HTML only (not a blocker), record `cv_file` as the HTML path (never a PDF path that was not produced), and say the PDF failed
   - The `/cv-gen` staleness gate (1b) and canon reconciliation (1c) apply here too, and HTML approval is still required before PDF; auto-pipe does not skip them

5. **Register in pipeline:**
   - Add/update `applications.json` entry:
     - status: `ready_to_apply` only if all three gate checks passed (title PASS, H1B SPONSORS, score >= 3.0). Otherwise follow `/eval` step 9 rules. Never overwrite `applied`/`interviewing`/`offer`.
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

- **PDF:** `output/cv/{company_key}_resume_{date}.pdf`
- **HTML:** `output/cv/{company_key}_resume_{date}.html`
- **Keywords injected:** {N}

---

### Pipeline Status

- **Status:** ready_to_apply
- **Eval:** `interview_prep/evaluations/{company}_{slug}_eval.json`
- **CV:** `output/cv/{company_key}_resume_{date}.pdf`

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
- **Score threshold is 3.0/5, and title + H1B are hard gates.** Below threshold or a failed gate, don't generate a CV unless the user explicitly overrides in that run.
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
