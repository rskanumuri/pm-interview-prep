# Fit Check — Role Fit Assessment & Gap-Bridging

Unified fit assessment tool. Answers "should I pursue this?" and "how do I bridge my gaps?" for any company. Reads existing artifacts, synthesizes a structured fit scorecard, and generates gap-bridging scripts.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

### Read (always)
- Resume: `sources/{active_user}/resume.txt`
- Source Materials: `sources/{active_user}/` (all personal docs — performance kit, stories, proof points)
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
- Evaluation: `interview_prep/evaluations/{company}_*_eval.json` (if exists — use Block B for JD requirements)

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

### Fit Dimensions (apply to every company)

1. **Domain Expertise** — Experience in the company's industry/product area
2. **Technical Match** — Technical background vs. role's technical requirements
3. **Seniority / Scope** — Experience level vs. role expectations (IC vs. lead, team size, revenue owned)
4. **Story Arsenal** — 3+ strong STAR stories that map to this company's interview themes
5. **Culture / Values Fit** — Working style alignment with company's stated values
6. **Unique Angle** — What the user brings that competitors for this role likely don't
7. **Conversation Shiftability** — Can the user plausibly shift the HM conversation from "what have you done?" to "here are your problems, let me show you how I'd solve them"? Score based on: (a) how well the user understands the company's current challenges, (b) whether their problem-solving approach maps to the company's needs, (c) whether the interview format allows this shift. A 5 means the user can walk the HM through their own problems using their frameworks. A 1 means the role requires domain credentials that can't be demonstrated through conversation.

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

When a company has multiple roles being tracked, files are keyed by `{company}_{role_slug}` instead of `{company}` alone.

**`{company_key}` resolution:**
- `role_slug` = role string lowercased, non-alphanumeric → underscores, collapsed (e.g., "Senior PM, Data Governance" → `senior_pm_data_governance`)
- If `<role>` argument is provided: `{company_key}` = `{company}_{role_slug}`
- If `<role>` argument is NOT provided: `{company_key}` = `{company}` (legacy single-role back-compat)

**Read order for file lookups:** try `{company}_{role_slug}_*` first if role provided; fall back to `{company}_*` if role-keyed files don't exist. This keeps existing single-role pipelines working without migration.

**All `{company}` references in file paths below should be interpreted as `{company_key}` per this rule.**

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

   **If any answer is ambiguous, STOP and ask the user about the role.** Frame as: "I'm reading this as {X}. Confirm or correct?" Never cross-reference user profile to calibrate — that corrupts the assessment.

   **Platform PM JDs describe what the platform SERVES, not what the PM OWNS.** Don't conflate the customers of the platform with the PM's scope.

1. **Read all data files** listed above for the target company
2. **Extract role requirements** from:
   - Insights file → role details, key responsibilities, requirements, "What They're Looking For"
   - Rubric → scoring dimensions
   - Cheat sheet → "Fit → JD Mapping" table
   - CLAUDE.md → company-specific context section
   - If none exist, warn and offer to run `/company-prep {company}` first
3. **Read the user's source docs** to inventory available experience and stories
4. **Score each of the 7 fit dimensions** (1-5) by matching role requirements against the user's experience
5. **Map each JD requirement** individually — score and cite evidence
6. **Identify gaps** — any dimension or requirement scoring 3 or below
7. **For each gap, draft a one-line bridge strategy**
8. **Check debrief history** — if debriefs exist, note how gaps played out in real interviews
9. **If 2+ companies have been fit-checked** (check progress.json for fit_score), show pipeline comparison
10. **Write fit fields to progress.json** under `company_readiness.{company}`
11. **Display the fit scorecard**

**Display:**

## FIT CHECK — {COMPANY} — {Role Title}

**VERDICT:** {STRONG FIT / FIT WITH GAPS / STRETCH / PASS} ({X.X}/5.0)

---

### JD Requirement Mapping

| Requirement | Score | Evidence |
|-------------|-------|----------|
| {8+ years B2B SaaS PM} | 5/5 | {specific proof} |
| {Cloud platform experience} | 5/5 | {specific proof} |
| {Developer tools experience} | 3/5 | {adjacent, bridge needed} |
| {Industry domain knowledge} | 2/5 | {no direct experience; bridge needed} |

---

### Fit Dimensions

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Domain Expertise | {X}/5 | {one-line rationale} |
| Technical Match | {X}/5 | {one-line rationale} |
| Seniority / Scope | {X}/5 | {one-line rationale} |
| Story Arsenal | {X}/5 | {N stories mapped, N themes covered} |
| Culture / Values Fit | {X}/5 | {one-line rationale} |
| Unique Angle | {X}/5 | {what user brings that others likely don't} |
| Conv. Shiftability | {X}/5 | {can user shift HM convo to problem-solving? why/why not} |

---

### Strengths -- Lead With These

1. **{Strength}** -- {proof point with number}
2. **{Strength}** -- {proof point with number}
3. **{Strength}** -- {proof point with number}

---

### Gaps -- Bridge Required

**Gap 1: {gap name}** (severity: {HIGH/MEDIUM/LOW})
- **Bridge:** "{one-sentence bridge strategy}"
- **Best story:** {story name}
- **Script:** {Yes -- see `scripts/{company}_gap_bridging.md` / No -- run `/fit-check {company} gaps`}

**Gap 2: {gap name}** (severity: {HIGH/MEDIUM/LOW})
- **Bridge:** "{one-sentence bridge strategy}"
- **Best story:** {story name}
- **Script:** {Yes/No}

---

### Debrief Evidence

*If debriefs exist:*
**From {interviewer} ({date}):**
- Strength confirmed: {what landed}
- Gap exposed: {what didn't land}
- Lesson: {actionable lesson}

*If no debriefs:* No interview data yet -- pre-interview assessment only.

---

### Pipeline Comparison

- **Stronger fit than:** {company X} ({X.X}/5)
- **Weaker fit than:** {company Y} ({Y.Y}/5)
- **Similar to:** {company Z} ({Z.Z}/5)
- *(Only shown if 2+ companies have fit_score in progress.json)*

---

### Recommended Actions

- `/fit-check {company} gaps` -- Generate gap-bridging scripts
- `/story-map {company}` -- Map stories to themes
- `/prep-check {company}` -- Readiness briefing

**progress.json update** — add/update these fields under `company_readiness.{company}`:
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
   - `## Gap N: {Name} ({severity}/5)` heading
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

## GAP ANALYSIS — {COMPANY}

**{N} gaps identified** | **{N} bridge scripts generated**

---

### Gap 1: {Gap Name} ({severity}/5)

**Prompt:** "You don't have {X} experience. How would you handle that?"

> {Full scripted bridge answer -- 3-4 paragraphs}
> {Adjacent STAR -> Bridge -> How I'd think -> First steps}

**Key line:** "{The memorable one-liner to anchor this answer}"

**Rules:**
- {Rule 1}
- {Rule 2}
- {Rule 3}

### Gap 2: {Gap Name} ({severity}/5)

*(same structure)*

---

### Unified Gap Answer -- "What gaps do you see?" (60-90 sec)

> {Full unified response naming gaps upfront, then pivoting to proof points}

---

### Universal Rules

1. Never introduce with what you lack. Lead with what you bring.
2. Max 3 items in any list.
3. No hedging words: "I would like to think", "hopefully"
4. Don't name the gap at the end.
5. Read the user's ramp-up proof points from CLAUDE.md or story_bank.json — use these as the anchor for all gap bridges.
6. Bridge pattern: Adjacent experience -> What's the same -> How I'd think about the new domain -> Specific first actions

---

### `compare` — Cross-Pipeline Fit Comparison

Compare fit scores across all active pipeline companies. Read-only — no writes.

**Steps:**

1. **Read progress.json** for all companies with `company_readiness` entries
2. **Read CLAUDE.md** for pipeline status (Active, Awaiting, Closed)
3. **For each active company**, check for `fit_score` in progress.json
   - If exists, use it
   - If not, read insights file for ad-hoc fit rating and convert to 1-5 scale
   - If no fit data exists at all, show "Not assessed — run /fit-check {company}"
4. **Filter out closed/rejected/dropped companies**
5. **Sort by fit score descending**
6. **Display comparison**

**Display:**

## FIT COMPARISON — Active Pipeline — {today's date}

| Company | Role | Fit | Stage | Verdict |
|---------|------|-----|-------|---------|
| {Company 1} | {Role Title} | 4.8/5 | {stage} | STRONG FIT |
| {Company 2} | {Role Title} | 4.3/5 | {stage} | STRONG FIT |
| {Company 3} | {Role Title} | 3.5/5 | {stage} | FIT WITH GAPS |

---

### Top Investment Priorities (next 7 days)

1. **{Company}** ({date}) -- {verdict}, {N} gaps need bridge scripts
   - -> `/fit-check {company} gaps`
2. **{Company}** ({date}) -- {verdict}, {issue}
   - -> {recommended action}

---

### Cross-Company Patterns

**Strongest themes across pipeline:**
- {themes the user covers well across multiple companies}

**Weakest themes across pipeline:**
- {themes that are gaps across multiple companies}

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

## FIT EVOLUTION — {COMPANY} — {N rounds completed}

---

### Timeline

| Stage | Score | Notes |
|-------|-------|-------|
| Pre-interview | {X.X}/5 | Based on: JD mapping |
| Round 1 | {X.X}/5 | {interviewer, date} |
| Round 2 | {X.X}/5 | {interviewer, date} |
| Current | {X.X}/5 | Adjusted for debrief evidence |

---

### Gap Tracking

| Gap | Pre-Interview | Reality |
|-----|--------------|---------|
| {Gap name} | HIGH concern | Did not come up (Round 1) |
| {Gap name} | Not flagged | EXPOSED in Round 2 |
| {Gap name} | MEDIUM concern | Bridge landed well |

---

### Updated Bridge Needs

- **{gap exposed}** -- needs new/revised bridge script
- **{gap resolved}** -- bridge worked well, keep as-is
- **{new insight}** -- adjust approach for next round

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
| No progress.json entry | Create one with fit fields only (minimal entry). |
| Company not registered | Ask: "Register {company}? (Y/n)" and add to companies.json. |

Always show what's missing and what command would fix it:

**Missing:** No insights file for {company}
- -> Run `/company-prep {company}` to create full prep scaffold
- -> Or `/process-sources {company}` if you have source materials

## Write Behavior

### Creates (on `gaps` command, with user confirmation)
- `interview_prep/scripts/{company}_gap_bridging.md`
  - Header with role context and rules
  - One section per gap: `## Gap N: {name} ({severity}/5)`
  - Prompt, blockquoted scripted answer, key line, rules per gap
  - Unified gap answer at the end
  - Universal rules section at the end

### Updates (on full assessment)
- `interview_prep/progress.json` — adds/updates fit fields in `company_readiness.{company}`

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
- **Pre-interview rules** (from CLAUDE.md) are automatic checks on all generated scripts.
- **No hedging in bridge scripts**: "I would like to think", "hopefully", "if not the same" — NEVER
- **Debrief evidence overrides pre-interview estimates** — if a gap was exposed in a real interview, escalate its severity regardless of initial assessment
- **Company key in filenames**: lowercase, underscores for spaces (e.g., `palo_alto_networks`)
- **Confidence calibration.** Every fit score ships with a confidence number (1-10) and the core assumption that drives it. Example: "4.3/5 STRONG FIT (confidence 7/10, assumes platform build role; if strategy/owner role, drops to 2.9/5)."
- **Role ambiguity is a stop condition.** If the Role Taxonomy pass flags ambiguity, ask about the role before scoring. Never cross-reference the user's profile to resolve role ambiguity — that corrupts the score.
