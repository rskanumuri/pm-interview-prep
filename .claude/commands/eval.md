---
description: "Score a JD against the target archetypes with a 6-block A-F evaluation to decide whether to apply. Use for evaluate role or check this JD."
---

# Eval — JD Evaluation & Role Scoring

Evaluate a job description against your experience using a 6-block A-F scoring framework. Answers "should I apply?" before committing prep time. This is top-of-funnel triage — complementary to `/fit-check` (which is deeper, interview-prep-oriented).

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

### Read (always)
- Resume: `sources/{active_user}/resume.txt`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, themes, company angles)
- Master Stories: `interview_prep/scripts/master_story_repository.md`
- Progress: `interview_prep/progress.json` (existing fit data, avoid duplicate work)
- Companies Registry: `interview_prep/companies.json`
- CLAUDE.md: `CLAUDE.md` (Job Search Config section — comp targets, archetypes, preferences)
- Applications: `interview_prep/applications.json` (existing pipeline)

### Read (if exists)
- Existing Evaluation: `interview_prep/evaluations/{company}_*_eval.json`
- Company Insights: `interview_prep/insights/{company}.md`
- Proof Points: `sources/{active_user}/proof_points_by_role.md`

### Write
- Evaluation: `interview_prep/evaluations/{company}_{role_slug}_eval.json`
- Applications: `interview_prep/applications.json` (add/update entry)
- Progress: `interview_prep/progress.json` (write eval_score/eval_verdict if company exists in company_readiness; never fit_score)

## Target Archetypes

Read the user's target archetypes from the "Target Archetypes" section of CLAUDE.md. For each archetype, CLAUDE.md should list:
- The archetype name
- Signal keywords to detect in JDs
- The user's proof points / evidence

Detect which archetypes the JD maps to. Multi-archetype overlap = stronger fit.

If no archetypes are defined in CLAUDE.md, warn the user and suggest they add a "Target Archetypes" section.

## Scoring Framework

### Letter Grades → Numeric (for progress.json compatibility)

| Grade | Numeric | Meaning |
|-------|---------|---------|
| A | 5.0 | Direct match — the user has done this exact thing |
| A- | 4.7 | Very strong — minor gap, easy bridge |
| B+ | 4.3 | Strong adjacent — natural bridge |
| B | 4.0 | Good match — some bridging needed |
| B- | 3.7 | Decent — multiple bridges required |
| C+ | 3.3 | Borderline — worth applying if other signals strong |
| C | 2.7 | Stretch — significant gaps (below the 3.0 apply threshold) |
| D | 2.0 | Weak — major gaps, unlikely to convert |
| F | 1.0 | Pass — no meaningful fit |

The map is strictly monotonic on purpose (no two grades share a number, and an all-C eval cannot reach the 3.0 threshold). Changed Oct 5, 2026; older evals used A-=B+=4.5 and C=3.0.

### Overall Verdict (same scale as /fit-check)

| Score Range | Verdict | Action |
|-------------|---------|--------|
| 4.0-5.0 | STRONG FIT | Apply immediately. Run `/company-prep`. |
| 3.0-3.9 | FIT WITH GAPS | Apply — but flag gaps for bridge prep. |
| 2.0-2.9 | STRETCH | Skip unless champion or referral exists. |
| 1.0-1.9 | PASS | Don't waste time. |

## Multi-Role File Keying

When writing eval artifacts, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, eval files are named `evaluations/{company}_{role_slug}_*_eval.json`, else fall back to `evaluations/{company}_*_eval.json` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<url-or-jd-text>` — Full 6-Block Evaluation

Evaluate a JD by URL or pasted text.

**Steps:**

1. **Obtain JD:**
   - If argument is a URL: fetch via WebFetch. If it fails, ask user to paste.
   - If argument is text: use directly.
   - Extract: company name, role title, requirements, responsibilities, nice-to-haves, location, level signals, team info.

2. **Check for prior work:**
   - Check `interview_prep/evaluations/` for existing eval of same company+role.
   - Check `progress.json` for existing company_readiness entry.
   - If found, note: "Prior eval/fit-check exists — this will update the record."

3. **Read user's profile:**
   - Resume for experience inventory
   - story_bank.json for canonical numbers and themes
   - CLAUDE.md Job Search Config for comp targets, archetypes, preferences

4. **Run the hard gates BEFORE scoring** (record results in Block A and in the eval JSON under `gates`):

   **Title gate.** If the title contains "project manager" or "program manager" (case-insensitive, including "technical program manager"), gate = `FAIL_TITLE`. The verdict is forced to PASS (cap 1.9), status becomes `closed`, and the eval stops after Block A unless the user says "override" in this run.

   **H1B gate.** The user currently holds an H1B (with the current employer), so any move needs a transfer; "sponsors" here means the employer files H1B transfers. Classify with evidence, and cite it:
   - `SPONSORS`: JD or careers page says sponsorship/transfer is available, OR recent LCA filings exist for PM-type roles (WebSearch `"{company}" H1B LCA site:h1bdata.info` or similar; cite the filing count and year).
   - `BLOCKED`: JD says no sponsorship or "must be authorized to work without sponsorship", OR a small/early company with no LCA history and no sponsorship language. Gate = `FAIL_H1B`: the verdict is capped at STRETCH (2.9), status becomes `closed` (reason: h1b), and the eval stops after Block A unless the user says "override".
   - `UNKNOWN`: no usable evidence. Do not guess. The verdict is capped at FIT WITH GAPS and labeled `CONDITIONAL: confirm transfer sponsorship before applying`; status stays `evaluating` and `ready_to_apply` is NOT set until the user confirms.

   A gate override is recorded as `gate_override: true` with the user's reason. Never override silently.

5. **Run 6-block evaluation:**

#### Block A — Role Summary

| Field | Value |
|-------|-------|
| Company | {name} |
| Role | {title} |
| Archetype(s) | {which archetypes match, comma-separated} |
| Archetype overlap | {count}/{total} |
| Level | {IC5/IC6/Lead/Manager — detected from JD signals} |
| Scope | {team size, revenue, products owned — from JD or inferred} |
| Location | {remote/hybrid/onsite, city} |
| H1B Gate | {SPONSORS / UNKNOWN / BLOCKED} — {evidence + source} |
| Title Gate | {PASS / FAIL_TITLE} |
| TL;DR | {one-sentence verdict} |

Grade: A-F based on archetype match count, level alignment, location fit.

#### Block B — Resume Match

Map every JD requirement against the user's experience:

| JD Requirement | Score | Evidence (with numbers) |
|----------------|-------|------------------------|
| {req 1} | {1-5} | {specific proof from resume/stories} |
| {req 2} | {1-5} | {specific proof or gap note} |
| ... | | |

- Score 5: User has done this exact thing with proof points
- Score 4: Strong adjacent experience, natural bridge
- Score 3: Transferable, requires scripted bridge
- Score 2: Thin connection
- Score 1: No meaningful experience

**CRITICAL**: Never invent experience. Only cite what's in the resume and story bank. If a requirement has no match, score it honestly and note the gap.

Grade: weighted average of requirement scores. Rules (so the grade cannot be padded):
- The requirement list is taken verbatim from the JD. Do not add generic requirements.
- Required/must-have = weight 2, nice-to-have = weight 1.
- Score each requirement 0-5 from the resume and story bank only. No evidence = 0, not "probably".
- Show the list, weights and scores so the math can be checked.

#### Block C — Level & Comp Strategy

- **Detected level** vs the user's natural level (read from CLAUDE.md or resume)
- **If downleveled**: note risk, comp impact, negotiation trigger
- **If upleveled**: note stretch areas, what user would need to demonstrate
- **Comp estimate**: use WebSearch for levels.fyi, Glassdoor, H1B LCA data
- **Comp vs target**: compare against CLAUDE.md comp targets

Grade: A if comp is at/above target + right level. D if significantly below or wrong level.

#### Block D — Comp Research

Use WebSearch to find:
- levels.fyi data for this company + level
- Glassdoor salary data
- H1B LCA filings (base salary indicator)
- Total comp range (base + bonus + equity)

| Source | Data Point | Confidence |
|--------|-----------|------------|
| {source} | {comp range} | {high/medium/low} |

Grade: based on comp alignment with targets from CLAUDE.md.

#### Block E — Application Strategy

- **Cover letter angles**: top 3 angles connecting the user's experience to this JD
- **Warm intro paths**: check if user has connections (from prior interviews, LinkedIn)
- **Outreach script**: 3-sentence LinkedIn message to HM or recruiter
- **Key differentiator**: what the user brings that other PM candidates likely don't

Grade: based on strength of narrative connection.

#### Block F — Interview Plan

- **Predicted format**: recruiter → HM → loop structure (from company Glassdoor, web search)
- **Key stories to prep** (top 5): map from story_bank.json themes to JD requirements
- **Gap preview**: which gaps will likely be probed, severity rating
- **Recommended prep sequence**: what to build first if pursuing

Grade: based on story arsenal coverage of JD themes.

6. **Calculate overall score:**
   - Average of 6 block grades (numeric)
   - Weight Block B (Resume Match) at 2x — it's the strongest predictor
   - Formula: (A + 2*B + C + D + E + F) / 7
   - Show 1 decimal, but apply thresholds to the UNROUNDED value (2.95 is STRETCH, not 3.0)
   - Block F counts only evidence not already counted in Block B (no double counting)
   - Apply gate caps from step 4 after averaging

7. **Display the evaluation:**

## EVAL — {COMPANY} — {Role Title}

**VERDICT:** {STRONG FIT / FIT WITH GAPS / STRETCH / PASS} ({X.X}/5.0)
**Archetypes:** {matched archetypes} ({N}/{total} overlap)

---

### Block A — Role Summary — Grade: {X}

- **Company:** {name}
- **Role:** {title}
- **Level:** {detected} | **Location:** {loc}
- **Scope:** {scope} | **H1B gate:** {SPONSORS/UNKNOWN/BLOCKED} | **Title gate:** {PASS/FAIL_TITLE}
- **TL;DR:** {one-liner}

---

### Block B — Resume Match — Grade: {X}

| Requirement | Score | Evidence |
|-------------|-------|----------|
| {requirement} | {X}/5 | {proof with numbers} |
| {requirement} | {X}/5 | {proof or gap} |

**Gaps:** {list of requirements scoring 2 or below}

---

### Block C — Level & Comp Strategy — Grade: {X}

- **Detected level:** {level}
- **Comp estimate:** {range} | **Target:** {from CLAUDE.md}
- {strategy note}

---

### Block D — Comp Research — Grade: {X}

| Source | Data | Confidence |
|--------|------|------------|
| {source} | {data} | {level} |

---

### Block E — Application Strategy — Grade: {X}

**Cover letter angles:**
1. {angle with proof point}
2. {angle with proof point}
3. {angle with proof point}

**Outreach:** "{3-sentence LinkedIn message}"
**Key differentiator:** {what user brings that others don't}

---

### Block F — Interview Plan — Grade: {X}

**Predicted format:** {stages}

**Key stories:**
1. {story name} — maps to {JD requirement}
2. {story name} — maps to {JD requirement}
3. {story name} — maps to {JD requirement}
4. {story name} — maps to {JD requirement}
5. {story name} — maps to {JD requirement}

**Gap preview:**
- {gap} — {severity} — {bridge available? Y/N}

---

### Recommended Actions

**If score >= 4.0:**
- Apply now. Run `/company-prep {company}` to build prep scaffold.
- Run `/fit-check {company}` for deep gap analysis.
- Run `/cv-gen {company}` to generate tailored resume.

**If score 3.0-3.9:**
- Worth pursuing with prep. Run `/fit-check {company} gaps` first.
- Check for referral/warm intro before cold applying.

**If score < 3.0:**
- Skip unless you have a champion. Time better spent elsewhere.

8. **Save evaluation:**
   - Write to `interview_prep/evaluations/{company}_{role_slug}_eval.json`
   - role_slug = lowercase, underscores, e.g. `senior_product_manager`
   - JSON structure:

```json
{
  "company": "{company}",
  "company_display": "{Company Display Name}",
  "role_title": "{Role Title}",
  "gates": { "title": "PASS|FAIL_TITLE", "h1b": "SPONSORS|UNKNOWN|BLOCKED", "h1b_evidence": "{source}", "gate_override": false },
  "jd_url": "{url or null}",
  "evaluated_date": "{YYYY-MM-DD}",
  "archetypes": ["{matched archetype IDs}"],
  "archetype_overlap": "{N}/{total}",
  "blocks": {
    "A_role_summary": { "grade": "{letter}", "score": "{numeric}", "level": "{detected}", "location": "{loc}", "h1b": "{signal}", "tldr": "{one-liner}" },
    "B_resume_match": { "grade": "{letter}", "score": "{numeric}", "matches": [{"requirement": "", "score": 0, "evidence": ""}], "gaps": [""] },
    "C_level_strategy": { "grade": "{letter}", "score": "{numeric}", "summary": "" },
    "D_comp_research": { "grade": "{letter}", "score": "{numeric}", "estimated_tc": "", "sources": [{"source": "", "data": "", "confidence": ""}] },
    "E_application_strategy": { "grade": "{letter}", "score": "{numeric}", "cover_angles": [""], "differentiator": "" },
    "F_interview_plan": { "grade": "{letter}", "score": "{numeric}", "predicted_format": "", "key_stories": [""], "gap_preview": [""] }
  },
  "overall_fit": 0.0,
  "verdict": "",
  "recommended_action": ""
}
```

9. **Update applications.json:**
   - Add or update entry with key `{company}_{role_slug}`
   - Only set status from `evaluating` or no entry. NEVER overwrite `applied`, `interviewing`, `offer`, or an existing `closed` reason; on a re-eval of those, update eval fields only.
   - `ready_to_apply`: score >= 3.0 (unrounded) AND title gate PASS AND H1B gate SPONSORS. H1B UNKNOWN stays `evaluating` with a note. Any FAIL gate or score < 3.0 → `closed` with the reason (`title`, `h1b`, or `score`).
   - Set eval_score, eval_file, discovered_date

10. **Update progress.json (if company exists):**
    - Write `company_readiness.{company}.eval_score` and `eval_verdict`. Do NOT overwrite `fit_score`/`fit_verdict`; those belong to `/fit-check` (debrief-informed).
    - Only if company_readiness entry already exists — don't create new ones (that's `/company-prep`'s job)

11. **Offer next steps:**
    - If score >= 4.0: "Run `/company-prep {company}` to build full prep scaffold?"
    - If score >= 3.0: "Run `/fit-check {company} gaps` for bridge scripts?"
    - Always: "Run `/save-push` to save?"

---

### `history` — Show All Evaluations

List all evaluations from `interview_prep/evaluations/`, sorted by score descending.

**Steps:**

1. Read all `*_eval.json` files in `interview_prep/evaluations/`
2. Read `interview_prep/applications.json` for current status
3. Display:

## EVALUATION HISTORY — {N} roles evaluated

| Score | Company | Role | Date | Status |
|-------|---------|------|------|--------|
| 4.8 | {Company} | {Role} | {date} | {status} |
| 4.2 | {Company} | {Role} | {date} | {status} |
| 3.5 | {Company} | {Role} | {date} | {status} |

### Pipeline Summary

- **Strong Fit (4.0+):** {N} | **Fit w/ Gaps (3.0-3.9):** {N}
- **Stretch (2.0-2.9):** {N} | **Pass (<2.0):** {N}
- **Applied:** {N} | **Interviewing:** {N} | **Ready to Apply:** {N}

---

### `batch` — Batch Evaluate Multiple JDs

Process multiple JDs at once. Input: list of URLs or files in `sources/inbox/jds/`.

**Steps:**

1. **Collect JDs:**
   - If URLs pasted: use them directly
   - If no argument: check `sources/inbox/jds/` for .txt/.md files
   - If no JDs found: ask user to paste URLs (one per line)

2. **For each JD:**
   - Run the full evaluation (same as single eval)
   - Save eval JSON
   - Update applications.json
   - Display a condensed one-line summary

3. **After all complete, display summary:**

## BATCH EVALUATION COMPLETE — {N} roles evaluated

| Score | Company | Role | Verdict |
|-------|---------|------|---------|
| 4.8 | {Company} | {Role} | **STRONG FIT** (recommended) |
| 4.2 | {Company} | {Role} | **STRONG FIT** (recommended) |
| 3.1 | {Company} | {Role} | FIT WITH GAPS |
| 2.3 | {Company} | {Role} | STRETCH |

### Next Steps

- **{N} roles scored 3.0+** — run `/company-prep` for each to build prep
- **Top pick:** {Company} ({score}/5) — {why}

4. Offer: "Run `/save-push` to save all evaluations?"

---

## Key Rules

- **Never invent experience.** Only cite what's in the resume, story bank, and source docs. If something isn't there, score it as a gap.
- **H1B and title are hard gates (step 4).** BLOCKED / FAIL_TITLE stop the eval after Block A unless the user explicitly overrides in that run. UNKNOWN is never treated as a pass.
- **Comp research is best-effort.** WebSearch may not find data for every company. Note confidence levels. Never guess comp numbers.
- **Archetype overlap is the strongest signal.** A JD matching 3+ archetypes is almost certainly a strong fit. A JD matching 0 is almost certainly a pass.
- **Block B weight is 2x** because resume match is the most objective predictor.
- **Canonical numbers** (from CLAUDE.md and story_bank.json) MUST be used exactly. Never round, never approximate.
- **Don't conflate products**: check story_bank.json for distinct product boundaries.
- **Score honestly.** A stretch is a stretch. Never introduce a story with what you lack.
- **This is triage, not deep prep.** Keep the eval focused. Don't write gap-bridging scripts or full answer preps — that's `/fit-check` and `/interview-prep`'s job.

## Integration with Other Skills

### Feeds Into
- `/fit-check` — reads eval JSON for JD requirements, skips re-parsing JD
- `/company-prep` — reads eval for archetype detection, keyword analysis, JD mapping
- `/cv-gen` — reads eval Block B for keyword injection
- `/auto-pipe` — orchestrates eval as step 1
- `/pipeline full` — reads applications.json for top-of-funnel view

### Receives From
- `/scan` — discovered roles that need evaluation
- `/process-sources` — JDs detected in inbox

### Cross-References in Output
- Score >= 4.0: "-> /company-prep {company}"
- Score >= 3.0: "-> /fit-check {company} gaps"
- Always: "-> /cv-gen {company}" and "-> /save-push"
