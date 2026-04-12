# /phantom — The Invisible Competitor You're Up Against

Generates the candidate who gets the job if you don't. Built purely from company, team, role, and market data — zero influence from your resume or background.

The phantom sharpens over rounds: V1 from JD → V2 from recruiter intel → V3 from HM intel → V4 from loop intel → Final from rejection post-mortem.

## Data Files (READ — company/role/market only)

- Company Insights: `interview_prep/insights/{company}.md`
- Company Rubric: `interview_prep/rubrics/{company}.md`
- Company Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md` (company/team intel ONLY — skip story maps, skip TMAY, skip anything about the user)
- JD/Eval: `interview_prep/evaluations/{company}_*_eval.json` (JD requirements ONLY — skip resume match block)
- CLAUDE.md: Company section only (NOT career thesis, NOT key numbers, NOT pipeline status)
- Debriefs: `interview_prep/answers/{company}_*_debrief_*.md` (for updates — read "New Intel" section only, NOT scores or performance)

## NEVER READ (for phantom generation)

- Resume, performance kit, proof_points_by_role, master stories
- progress.json fit scores or story scores
- Career thesis, key numbers, pre-interview rules
- Any file in `sources/{active_user}/`

The phantom is the objective benchmark. Your data enters ONLY in the `gap` subcommand.

## Multi-Role File Keying

When a company has multiple roles being tracked, files are keyed by `{company}_{role_slug}` instead of `{company}` alone, so each role's phantom is distinct.

**`{company_key}` resolution:**
- `role_slug` = role string lowercased, non-alphanumeric → underscores, collapsed (e.g., "Senior PM, Data Governance" → `senior_pm_data_governance`)
- If `<role>` argument is provided: `{company_key}` = `{company}_{role_slug}`
- If `<role>` argument is NOT provided: `{company_key}` = `{company}` (legacy single-role back-compat)

**Read order for file lookups:** try `{company}_{role_slug}_*` first if role provided; fall back to `{company}_*` if role-keyed files don't exist.

**All `{company}` references in file paths below should be interpreted as `{company_key}` per this rule.**



Parse `$ARGUMENTS`:

### `<company>` — Generate the Phantom

**Steps:**

1. **Read company/role data** from insights, rubric, cheat sheet (company intel only), CLAUDE.md company section
2. **Read the JD** from eval file or cheat sheet role description

3. **Role Taxonomy Pass (MANDATORY — do this before anything else):**

   Before generating the phantom, articulate the role taxonomy in writing. Answer three questions from the JD alone:

   - **Builder or Owner?** Does the PM ship infrastructure/capabilities, or own a business outcome/strategy?
   - **Craft or Domain?** Is the primary skill the craft (platform building, ML, experimentation, CI) or domain knowledge (auto retail, healthcare, fintech)?
   - **Day-30 Deliverable?** What will this PM ship in their first month — a strategy deck, a platform capability, a shipped feature, a pricing model, an analysis?

   **If ANY answer is ambiguous from the JD alone, STOP and ask the user about the role.** Frame the question:
   ```
   "Before I build the phantom, I'm reading this role as {X}. Is that right, or is it actually {Y}?"
   ```

   **CRITICAL: Ask about the ROLE, never cross-reference the user's profile to calibrate.** Candidate cross-reference corrupts the phantom's objectivity. The phantom is built from company/role/market data ONLY.

   **Common ambiguity traps:**
   - "Platform" in the team name could mean infrastructure platform OR business platform. Check the JD bullets — do they describe what gets built or what gets strategized?
   - **Platform PM JDs describe what the platform SERVES, not what the PM OWNS.** "Spanning new entrants, franchise manufacturers, D2C" describes the customers of the platform, not the PM's scope.
   - "Special projects" could mean strategy consulting OR platform scaffolding. Look at deliverables.
   - Domain-heavy language in the JD context (industry terms, market dynamics) doesn't mean domain expertise is required — it may just be describing the business the platform serves.

4. **Research** using WebSearch:
   - "what makes someone successful at {company}"
   - "{company} interview tips {role}"
   - "{role} day in the life"
   - "{company} culture what they look for"
   - "{company} glassdoor interview experience"
   - LinkedIn: typical background of people in this role at this company

5. **Generate 4-dimension phantom** and write to `interview_prep/scripts/{company}_phantom.md`. Include the Role Taxonomy at the top of the file so the archetype is traceable.

**Output format:**

```markdown
# The Phantom — {Company} {Role Title}
**Generated:** {date} | **Version:** V{N} | **Based on:** {JD / JD + recruiter intel / JD + HM intel / etc.}

---

## Dimension 1: Experience Profile

### What's on their resume
{Specific prior roles, companies, scope — NOT generic. "5 years at a Snowflake competitor like Databricks or Confluent as a CI analyst, plus 3 years in product marketing at an enterprise data company."}

### The numbers they'd cite
{Specific metrics this person would have: "Improved competitive win rate from 42% to 58% over 18 months", "Built battle card program used by 500+ sellers", "Owned positioning for 3 product lines against 5 key competitors"}

### What makes them different from the other 100 applicants
{The 1-2 things that make the recruiter stop scrolling}

---

## Dimension 2: Interview Prep

### How they'd prepare
{What research, what artifacts they'd build before the interview}

### The 5 stories they'd have ready
{Specific story THEMES with the kind of proof points they'd cite — not generic "a time I led a team"}

### Domain phrases they'd deploy naturally
{10 phrases that signal insider knowledge — specific to this company and role}

### Questions they'd ask that signal insider thinking
{5 questions that make the HM think "this person already understands our problems"}

### Their closing statement
{The last thing they'd say that makes the HM want to hire them}

---

## Dimension 3: Interview Performance

### How their TMAY sounds
{Energy, pacing, hooks — what the first 60 seconds feel like to the interviewer}

### How they handle follow-ups
{Depth without rambling — 30-second follow-up answers, not 3-minute restarts}

### How they handle gaps
{One sentence acknowledging, immediate pivot to adjacent strength, no dwelling}

### How they handle pushback
{Hold position with evidence. Adapt when the interviewer has a point. No collapsing, no defensiveness.}

### What the interviewer writes in their debrief
{The actual debrief notes — "Strong hire. Deep domain knowledge. Crisp communicator. Already thinking about our problems."}

### What they do NOT do
{Anti-patterns — what the phantom avoids that weaker candidates fall into}

---

## Dimension 4: On the Job (First 90 Days)

### Week 1
{Who they'd meet, what they'd read, what they'd observe}

### Day 30
{What they'd ship or present. What relationships they'd have built. First visible impact.}

### Day 60
{What they'd own. What decisions they'd have made. What the team says about them.}

### Day 90
{What the HM says in their first review. The sentence that confirms "this was the right hire."}

---

## The Phantom's Edge — Why They Win
{2-3 sentences on what makes this person beat every other candidate. Not skills — positioning. Not experience — narrative.}
```

5. **Report:**
   ```
   Phantom generated for {company}.
   📄 `interview_prep/scripts/{company}_phantom.md`
   Run `/phantom {company} gap` to see where you stand against them.
   ```

### `<company> gap` — Delta Analysis

**This is the ONLY subcommand that reads personal data.**

**Steps:**

1. Read the phantom: `interview_prep/scripts/{company}_phantom.md`
2. Read user data: resume, performance kit, fit-check scores from progress.json, relevant debriefs
3. For each dimension of the phantom, compare against the user's actual profile
4. Display:

```markdown
## PHANTOM GAP ANALYSIS — {Company}

| Dimension | The Phantom | You | Delta | How to Close |
|-----------|-------------|-----|-------|-------------|
| Experience | {what phantom has} | {what you have} | {the gap} | {specific action} |
| Domain phrases | {phantom deploys 10 naturally} | {you have 5 prepped} | {5 missing} | {study X, practice Y} |
| TMAY energy | {crisp 45 sec, confident} | {tends to run 90 sec, flat open} | {pacing + energy} | {timer reps, record and listen} |
| Follow-up depth | {30-sec targeted answers} | {tends to restart story} | {practice stopping at 30 sec} | {drill-rapid with follow-ups} |
| On the Job | {ships in week 2} | {similar velocity} | {none — matched} | — |

### Where You Beat the Phantom
{Dimensions where the user is actually stronger than the typical competitor}

### The 3 Gaps That Matter Most
1. {gap} — {why it matters for THIS role} — {fix}
2. {gap} — {why} — {fix}
3. {gap} — {why} — {fix}
```

### `<company> performance` — Interview Performance Card Only

Quick extract of Dimension 3 only. For pre-interview review — read this 30 minutes before the call to calibrate energy and pacing.

### `<company> update` — Sharpen After New Intel

Read the latest debrief for this company. Update the phantom with new intelligence:
- What the interviewer revealed they're looking for
- What team challenges surfaced
- What other candidates apparently had
- Show what changed: "Phantom V{N} → V{N+1}: added {detail} from {interviewer} intel"

## Auto-Triggers

### Trigger 1: Recruiter call scheduled → generate V1
**Where:** `.claude/commands/interview-prep.md` — when Stage 1 (Recruiter) prep is run
**What:** Auto-generate `{company}_phantom.md` V1 from JD + company research
**Show:** "Phantom V1 generated for {company}."

### Trigger 2: After each debrief → sharpen
**Where:** `.claude/commands/debrief.md` — Step 6.5
**What:** After debrief is saved, if `{company}_phantom.md` exists, offer: "Sharpen the phantom with intel from this round?"
If yes: run `/phantom <company> update`

### Trigger 3: After rejection → post-mortem
**Where:** `CLAUDE.md` Career Learning Hooks (archiving flow)
**What:** When archiving, update phantom with: "The candidate who got this job probably had X." Final version becomes a learning artifact.

## Key Rules

- **The phantom is OBJECTIVE.** Zero influence from the user's resume, skills, or background. Built entirely from company, team, role, JD, and market factors.
- **Be specific, not generic.** "5 years at Databricks as a CI analyst" not "experience in data analytics." "Improved win rate from 42% to 58%" not "strong competitive track record."
- **Include what the phantom does NOT do.** Anti-patterns are as valuable as patterns.
- **The phantom must be realistic.** Someone who could actually exist and apply for this role. Not a fantasy composite of every possible strength.
- **Use the rubric.** If `rubrics/{company}.md` exists, the phantom scores 5 on every dimension. Describe what that looks like concretely.
- **On the Job must reference real company challenges.** Pull from insights, cheat sheet intel, and web research. "Day 30: ships a Fabric competitive teardown" not "Day 30: builds relationships."
- **Use Opus** for this skill — it requires judgment, synthesis, and nuance. Never route to Sonnet.
- **Version tracking.** Every phantom has a version number (V1, V2, V3...) and a "Based on" line showing what intel informed it.
- **Confidence calibration.** Every phantom ships with a confidence score (1-10) and the core assumption that drives it. Example: "Confidence 7/10, assumes this is a platform build role. If strategy/owner role, archetype flips entirely." If the Role Taxonomy was ambiguous and required user clarification, flag this in the confidence line.
- **Role ambiguity is a stop condition, not a guess trigger.** If the Role Taxonomy pass flags ambiguity, the skill MUST ask the user about the role before proceeding. Never generate a phantom on a guessed framing.
