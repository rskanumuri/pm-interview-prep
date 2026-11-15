---
description: "Role fit scorecard and gap-bridging scripts for a company. Use for fit for role."
argument-hint: "<company> [role] [gaps | jd | evolution] | compare"
---

# Fit Check — Role Fit Assessment & Gap-Bridging

Unified fit assessment tool. Answers "should I pursue this?" and "how do I bridge my gaps?" for any company. Reads existing artifacts, synthesizes a structured fit scorecard, and generates gap-bridging scripts.

## Rules that must hold (kept at the top because a context compaction keeps only the start of a skill)

- **Role Taxonomy pass and HM-lens MSN come before any user data is read.** If the role is ambiguous, stop and ask about the role; never use the user's profile to resolve it.
- **Score honestly; no inflation.** A transferable-skill 4 needs a NAMED story from `story_bank.json` or the resume in the evidence column, else the cap is 3. Debrief evidence overrides a hypothetical bridge. The verdict follows the average, never the reverse.
- **Overall = average of dimensions 1 to 6.** Conversation Shiftability (7) is reported separately.
- **Gaps:** any dimension or requirement at 3 or below gets a bridge; HM-inferred Musts at 2 or below are HIDDEN-MUST GAPs with the verify question.
- **Bridge scripts are speakable,** max 3 proof points, no hedging, never open with what the candidate lacks.
- **Numbers come from canon** (`interview_prep/reference/skills_core.md` §5).
- **Never credit current-employer internals** as evidence in a passive-pipeline fit-check.
- **Every score ships with a confidence (1-10) and its core assumption.**
- **Writes:** `fit_*` keys in progress.json only, after a before/after and a yes (`skills_core.md` §2). Never touch `eval_*`.
- For a closed company, its rubric, insights and debriefs are in `sources/{company}/`.
- The display layouts further down are layouts. Their sample figures (years, scores, company names) are not data; never copy one into output.

## Active User

Rule: `interview_prep/reference/skills_core.md` §4. Read `progress.json` `active_user`; personal material comes only from `sources/{active_user}/` and `interview_prep/story_bank.json`.

## Data Files

### Read (always)
- Resume: `sources/{active_user}/resume.txt`
- Performance Kit: `sources/{active_user}/interview_performance_kit_v2.txt` (carries superseded sections; see the banner at its top. Prefer `story_bank.json` for stories and numbers)
- Company guides (for example a leadership-principles guide): `sources/{company}/...` (read ONLY when the company needs it; otherwise grep for a specific theme)
- Proof Points: `sources/{active_user}/proof_points_by_role.md`
- Master Stories: `interview_prep/scripts/master_story_repository.md`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, story inventory)
- Progress: `interview_prep/progress.json`
- Companies Registry: `interview_prep/companies.json`
- CLAUDE.md: `CLAUDE.md` (company context sections, career thesis, pre-interview rules)

### Read (per company)
- Company Insights: `interview_prep/insights/{company}.md`
- Company Rubric: `interview_prep/rubrics/{company}.md`
- Company Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md`
- Gap-Bridging Scripts: `interview_prep/scripts/{company}_gap_bridging.md` (if exists)
- Debriefs: `interview_prep/answers/{company}_*_debrief_*.md`
- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Evaluation: `interview_prep/evaluations/{company}_*_eval.json` (if exists, use Block B for JD requirements)

### Write (optional)
- Gap-Bridging Scripts: `interview_prep/scripts/{company}_gap_bridging.md`
- Progress: `interview_prep/progress.json` (update fit fields in company_readiness)

## Fit Scoring Framework

### Dimension Scoring (1-5)

| Score | Label | Meaning |
|-------|-------|---------|
| 5 | Direct match | User has done this exact thing, with proof points and numbers |
| 4 | Strong adjacent | User has done something very similar; bridge is natural and credible |
| 3 | Bridgeable | User has transferable skills; requires a scripted bridge answer |
| 2 | Stretch | Weak connection; bridge is thin and may not convince a skeptic |
| 1 | Gap | No meaningful experience; honest gap, ramp-up story only |

### IMPORTANT: Scoring Philosophy

Score based on what the user CAN DO, not just what they DID. When assessing fit:
- Don't penalize for scope boundaries ("they only built part of the platform"). Score the PROBLEM they solved and HOW.
- Ask: "Can this person shift the HM conversation to problem-solving for THIS role?" If yes, the fit is higher than the resume suggests.
- Don't artificially narrow fit based on product category when the underlying skills transfer.
- If the user can credibly walk a HM through how they'd solve their specific challenges using transferable experience, that's a 4, not a 2.

**Guard against inflation (added Oct 5, 2026).** "Can do" must be earned, not assumed:
- A transferable-skill credit (a 4 where the experience is adjacent) requires a NAMED story from `story_bank.json` or the resume that demonstrates the skill, cited in the evidence column. No named story means the cap is 3.
- Scores are checked against the real record when it exists: if debriefs show a dimension failed in a live round, the dimension cannot score above what the debrief supports; show the debrief evidence next to the score. A rubric-strict debrief score beats a hypothetical bridge.
- Never raise a score to make the overall land on a verdict. The verdict follows the average, not the reverse.
- Do not credit confidential employer-internal material as evidence in a fit-check.

### Fit Dimensions (apply to every company)

1. **Domain Expertise** — Experience in the company's industry/product area
2. **Technical Match** — Technical background vs. role's technical requirements
3. **Seniority / Scope** — Experience level vs. role expectations (IC vs. lead, team size, revenue owned)
4. **Story Arsenal** — 3+ strong STAR stories that map to this company's interview themes
5. **Culture / Values Fit** — Working style alignment with company's stated values
6. **Unique Angle** — What the user brings that competitors for this role likely don't
7. **Conversation Shiftability** — Can the user plausibly shift the HM conversation from "what have you done?" to "here are your problems, let me show you how I'd solve them"? Score based on: (a) how well the user understands the company's current challenges, (b) whether their problem-solving approach maps to the company's needs, (c) whether the interview format allows this shift. A 5 means the user can walk the HM through their own problems using their frameworks. A 1 means the role requires domain credentials that can't be demonstrated through conversation.

**Averaging:** the overall score is the average of dimensions 1-6. Dimension 7 (Conversation Shiftability) is reported separately as a modifier and is NOT averaged in, because it is a subjective estimate of the user's own delivery and was lifting averages.

### Overall Verdict

| Avg Score | Verdict | Recommendation |
|-----------|---------|----------------|
| 4.0-5.0 | STRONG FIT | Pursue aggressively — lead with strengths |
| 3.0-3.9 | FIT WITH GAPS | Pursue — but prepare bridge scripts for every gap |
| 2.0-2.9 | STRETCH | Consider carefully — requires strong bridges and a champion |
| 1.0-1.9 | PASS | Not worth the time investment unless other factors override |

### Gap Severity

- **HIGH** — Likely to be asked directly AND hard to bridge (e.g., no industry experience)
- **MEDIUM** — May come up AND bridgeable with adjacent experience
- **LOW** — Unlikely to be probed OR easy to bridge naturally

## Multi-Role File Keying

Rule: `interview_prep/reference/skills_core.md` §3 (how `{company_key}` is formed, role-keyed lookup first, where closed-company files live). Accepts an optional `<role>` arg. Every `{company}` in a file path below means `{company_key}`.



Parse `$ARGUMENTS` to determine the command:

### `<company>` — Full Fit Scorecard

Comprehensive fit assessment for a specific company/role.

**Steps:**

0. **Role Taxonomy Pass (MANDATORY — before reading user data):**

   Answer three questions from the JD alone:
   - **Builder or Owner?** Does the PM ship infrastructure/capabilities, or own a business outcome/strategy?
   - **Craft or Domain?** Is the primary skill the craft (platform building, ML, experimentation, CI) or domain knowledge?
   - **Day-30 Deliverable?** What will this PM actually ship in their first month?

   **If any answer is ambiguous, STOP and ask the user about the role.** Frame as: "I'm reading this as {X}. Confirm or correct?" Never cross-reference user profile to calibrate, that corrupts the assessment.

   **Platform PM JDs describe what the platform SERVES, not what the PM OWNS.** Don't conflate the customers of the platform with the PM's scope.

0.5. **HM-lens MSN (before reading user data).** Read `interview_prep/evaluations/{company_key}_hm_msn.md`. If missing, build V1 per `interview_prep/reference/hm_lens_msn_method.md` and save it. If newer recruiter/HM intel exists than the MSN version, run the method's Update step first (V2+).

1. **Read all data files** listed above for the target company
2. **Extract role requirements** from:
   - Insights file → role details, key responsibilities, requirements, "What They're Looking For"
   - Rubric → scoring dimensions
   - Cheat sheet → "Fit → JD Mapping" table
   - CLAUDE.md → company-specific context section
   - If none exist, warn and offer to run `/company-prep {company}` first
3. **Read the user's source docs** to inventory available experience and stories
4. **Score each of the 7 fit dimensions** (1-5) by matching role requirements against the user's experience
5. **Map each JD requirement** individually — score and cite evidence. Then append each MSN Must and Should that is not already a JD requirement as its own row, Source = HM-inferred
6. **Identify gaps** — any dimension or requirement scoring 3 or below, including HM-inferred Musts (label those HIDDEN-MUST GAP and carry the MSN verify question into the bridge) (a fit-check gap needs a bridge SCRIPT; `/eval` calls 2 or below a "major gap". The two thresholds are intentionally different, so do not compare raw gap counts across the two skills)
7. **For each gap, draft a one-line bridge strategy**
8. **Check debrief history** — if debriefs exist, note how gaps played out in real interviews
9. **If 2+ companies have been fit-checked** (check progress.json for fit_score), show pipeline comparison
10. **Write fit fields to progress.json** under `company_readiness.{company}` (this company's `fit_*` keys only). Show the before/after and wait for the user's yes first; never touch `eval_score`/`eval_verdict` (owned by `/eval`) or reformat the file
11. **Display the fit scorecard**

**Display:**

**Layout:** `interview_prep/reference/skill_templates/fit-check.md`, section "Fit scorecard display". Read it when producing this output; its sample values are placeholders.

**progress.json update**: add/update these fields under `company_readiness.{company}`:
```json
{
  "fit_score": 4.2,
  "fit_verdict": "STRONG FIT",
  "fit_dimensions": {
    "domain_expertise": 4,
    "technical_match": 5,
    "seniority_scope": 4,
    "story_arsenal": 5,
    "culture_values": 4,
    "unique_angle": 3,
    "conversation_shiftability": 4
  },
  "fit_gaps": ["domain expertise (specific industry)"],
  "fit_date": "YYYY-MM-DD"
}
```

---

### `<company> gaps` — Gap Analysis with Bridge Scripts

Focused deep-dive on gaps. Generates full gap-bridging scripts.

**Steps:**

1. **Read the fit assessment data** (same sources as full assessment)
2. **Read existing gap-bridging scripts** as format templates (if any exist in `interview_prep/scripts/`)
3. **Identify all gaps** — any JD requirement or fit dimension scoring 3 or below
4. **For each gap, generate a full bridge script** following this EXACT structure:
   - `## Gap N: {Name} ({severity})` heading
   - `**Prompt:**` the likely interview question that probes this gap
   - Blockquoted scripted answer using the bridge pattern:
     - Adjacent STAR with specific proof points (max 3)
     - Bridge to how the same skill applies to this role
     - "Here's how I'd think about it" framing for the new domain
     - Specific first steps or actions
   - `**Key line:**` the memorable sound bite from the answer
   - `**Rules:**` 3-4 specific do's and don'ts for this answer
5. **Generate a unified gap answer** — "What gaps do you see?" response (60-90 seconds)
6. **Include Universal Rules for Gap-Bridging**
7. **Ask user**: "Save to `interview_prep/scripts/{company}_gap_bridging.md`?"
8. **If yes, write the file**

**Display:**

**Layout:** `interview_prep/reference/skill_templates/fit-check.md`, section "Gap analysis display". Read it when producing this output; its sample values are placeholders. The Universal Rules for gap-bridging are part of this section and must be included in the saved file.

---

### `compare` — Cross-Pipeline Fit Comparison

Compare fit scores across all active pipeline companies. Read-only — no writes.

**Steps:**

1. **Read progress.json** for all companies with `company_readiness` entries
2. **Read CLAUDE.md** for pipeline status (Active Pipeline section)
3. **For each active company**, check for `fit_score` in progress.json
   - If exists, use it
   - If not, read insights file for ad-hoc fit rating and convert to 1-5 scale
   - If no fit data exists at all, show "Not assessed, run /fit-check {company}"
4. **Filter out closed/rejected/dropped companies**
5. **Sort by fit score descending**
6. **Display comparison**

**Display:**

**Layout:** `interview_prep/reference/skill_templates/fit-check.md`, section "Comparison display". Read it when producing this output; its sample values are placeholders.

---

### `<company> jd` — JD-Based Assessment

For early-pipeline companies without prep artifacts. User pastes a JD for instant fit scoring.

**Steps:**

1. **Check if company is registered** in companies.json
   - If no, ask: "Register {company}? (Y/n)" and add minimal entry if yes
2. **Check for existing evaluation** in `interview_prep/evaluations/{company}_*_eval.json`
   - If found: read the eval data and use Block B (resume match) data directly. Inform user: "Using existing /eval data from {date}. Re-paste JD to override."
   - If found and user doesn't override: skip to step 4 using eval data as the JD requirements source
3. **If no eval exists, ask user to paste the JD** (or provide a URL to fetch)
4. **Parse JD for requirements:**
   - Required years of experience
   - Required technical skills
   - Required domain knowledge
   - Nice-to-haves
   - Level indicators
   - Values/culture signals
5. **Read the user's source docs** to match against JD requirements
6. **Score and display** using the same template as `<company>` command
7. **Offer next steps:**
   - "Save as company insights? -> updates insights/{company}.md"
   - "Generate gap-bridging scripts? -> /fit-check {company} gaps"
   - "Full company prep? -> /company-prep {company}"

---

### `<company> evolution` — Fit Evolution Tracking

Track how fit assessment has changed across interview rounds. Read-only — no writes.

**Steps:**

1. **Read all debriefs** for the company: `interview_prep/answers/{company}_*_debrief_*.md`
2. **Read current fit assessment** from insights file and progress.json
3. **Read progress.json** for score history
4. **Compile evolution:**
   - Pre-interview fit estimate (from insights or initial fit-check)
   - Per-round debrief scores and outcomes
   - Gaps confirmed vs. gaps that turned out to be non-issues
   - New gaps discovered during interviews
   - Lessons that changed the fit picture
5. **Display evolution**

**Display:**

**Layout:** `interview_prep/reference/skill_templates/fit-check.md`, section "Evolution display". Read it when producing this output; its sample values are placeholders.

---

## Handling Missing Artifacts

If artifacts are missing, degrade gracefully but don't block the assessment:

| Missing Artifact | Behavior |
|-----------------|----------|
| No insights file | Warn. Use CLAUDE.md company section if present. Offer `/company-prep {company}`. |
| No rubric | Skip Culture/Values dimension detail. Use general company values from insights if available. |
| No cheat sheet | Skip JD Mapping cross-reference. Assess from insights + CLAUDE.md only. |
| No gap-bridging scripts | Expected — that's what `gaps` command generates. Show "No scripts yet." |
| No debriefs | Show "No interview data yet — pre-interview assessment only." |
| No progress.json entry | Offer to create a minimal entry with fit fields only; create it after the user's yes. |
| Company not registered | Ask: "Register {company}? (Y/n)" and add to companies.json. |

Always show what's missing and what command would fix it:

**Missing:** No insights file for {company}
- -> Run `/company-prep {company}` to create full prep scaffold
- -> Or `/process-sources {company}` if you have source materials

## Write Behavior

### Creates (on `gaps` command, with user confirmation)
- `interview_prep/scripts/{company}_gap_bridging.md`
  - Header with role context and rules
  - One section per gap: `## Gap N: {name} ({severity})`
  - Prompt, blockquoted scripted answer, key line, rules per gap
  - Unified gap answer at the end
  - Universal rules section at the end

### Updates (on full assessment)
- `interview_prep/progress.json`: adds/updates fit fields in `company_readiness.{company}`

### Never Overwrites Without Asking
- Existing gap-bridging scripts — ask user: "File exists. Overwrite / Merge / Skip?"
- Insights files — managed by `/company-prep` and `/process-sources`
- Rubrics — managed by `/company-prep` and `/process-sources`

## Integration with Other Skills

### Feeds Into
- `/prep-check` — fit-check's gap/bridge data appears in prep-check's "KNOWN GAPS — Bridge Ready" section
- `/story-map` — fit-check's story arsenal assessment identifies which stories need mapping
- `/pm-practice` — gap-bridging scripts become practice prompts

### Receives From
- `/company-prep` — creates the insights, rubric, and cheat sheet that fit-check reads
- `/debrief` — creates debrief files that fit-check uses for evolution tracking
- `/process-sources` — enriches insights files with new data
- `/pipeline` — provides stage/status context for compare view

### Cross-References in Output
- Every gap: "-> Generate bridge script: /fit-check {company} gaps"
- Every assessment: "-> Map stories: /story-map {company}"
- Every assessment: "-> Readiness check: /prep-check {company}"
- Missing prep: "-> Full scaffold: /company-prep {company}"
- After generating scripts: "-> Practice: /pm-practice {company}"

## Key Rules

- **Read actual source docs** every time — don't rely on cached assessments. Stories and experience evolve.
- **Score honestly** — a stretch is a stretch. Pre-interview rule: "Never introduce a story with what you lack."
- **Severity labels matter** — HIGH means "likely to be asked and hard to bridge." MEDIUM means "may come up but bridgeable." LOW means "unlikely to be asked or easy to bridge."
- **Bridge scripts must be speakable** — write them as spoken responses (contractions, natural rhythm), not as written documents. Test: could the user read this aloud and sound natural?
- **Max 3 proof points per bridge** — "Brain can't hold more in a conversation."
- **Read the user's ramp-up proof points from CLAUDE.md or story_bank.json** — use these as the universal anchor for all gap bridges.
- **Career thesis** (from CLAUDE.md) must connect to the company somehow — if it doesn't, flag as a culture fit signal.
- **Pre-interview rules:** the pre-interview rules in `interview_prep/reference/skills_core.md` §6 are automatic checks on everything this skill writes
- **No hedging in bridge scripts**: "I would like to think", "hopefully", "if not the same" — NEVER
- **Debrief evidence overrides pre-interview estimates** — if a gap was exposed in a real interview, escalate its severity regardless of initial assessment
- **Company key in filenames**: lowercase, underscores for spaces (e.g., `palo_alto_networks`)
- **Confidence calibration.** Every fit score ships with a confidence number (1-10) and the core assumption that drives it. Example: "4.3/5 STRONG FIT (confidence 7/10, assumes platform build role; if strategy/owner role, drops to 2.9/5)."
- **Role ambiguity is a stop condition.** If the Role Taxonomy pass flags ambiguity, ask about the role before scoring. Never cross-reference the user's profile to resolve role ambiguity — that corrupts the score.
