# Display layouts and templates for /fit-check

Kept outside `.claude/commands/fit-check.md` to keep the skill short enough to survive a context compaction. The skill points here; read the section you need when rendering. Sample values in these layouts (names, scores, dates, counts) are placeholders, not data: never copy one into output. Headings shown with a dash are written with a colon in generated files (`interview_prep/reference/skills_core.md` section 7).

---

<!-- section: Fit scorecard display -->

# SECTION: Fit scorecard display

## FIT CHECK: {COMPANY}, {Role Title}

**VERDICT:** {STRONG FIT / FIT WITH GAPS / STRETCH / PASS} ({X.X}/5.0)

---

### JD Requirement Mapping

| Requirement | Source | Score | Evidence |
|-------------|--------|-------|----------|
| {8+ years B2B SaaS PM} | JD | 5/5 | {specific proof} |
| {Cloud platform experience} | JD | 5/5 | {specific proof} |
| {Developer tools experience} | JD | 3/5 | {adjacent, bridge needed} |
| {Industry domain knowledge} | JD | 2/5 | {no direct experience; bridge needed} |
| {Must from MSN, e.g. migration-under-deadline} | HM-inferred | 2/5 | HIDDEN-MUST GAP; verify: "{question}" |

---

### Fit Dimensions

| Dimension | Score | Rationale |
|-----------|-------|-----------|
| Domain Expertise | {X}/5 | {one-line rationale} |
| Technical Match | {X}/5 | {one-line rationale} |
| Seniority / Scope | {X}/5 | {one-line rationale} |
| Story Arsenal | {X}/5 | {N stories mapped, N themes covered} |
| Culture / Values Fit | {X}/5 | {one-line rationale} |
| Unique Angle | {X}/5 | {what the user brings that others likely don't} |
| Conv. Shiftability | {X}/5 | {can the user shift HM convo to problem-solving? why/why not} |

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


---

<!-- section: Gap analysis display -->

# SECTION: Gap analysis display

## GAP ANALYSIS: {COMPANY}

**{N} gaps identified** | **{N} bridge scripts generated**

---

### Gap 1: {Gap Name} ({severity})

**Prompt:** "You don't have {X} experience. How would you handle that?"

> {Full scripted bridge answer -- 3-4 paragraphs}
> {Adjacent STAR -> Bridge -> How I'd think -> First steps}

**Key line:** "{The memorable one-liner to anchor this answer}"

**Rules:**
- {Rule 1}
- {Rule 2}
- {Rule 3}

### Gap 2: {Gap Name} ({severity})

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
5. Read the user's ramp-up proof points from CLAUDE.md or story_bank.json and use them as the anchor for all gap bridges.
6. Bridge pattern: Adjacent experience -> What's the same -> How I'd think about the new domain -> Specific first actions


---

<!-- section: Comparison display -->

# SECTION: Comparison display

## FIT COMPARISON: Active Pipeline, {today's date}

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

<!-- section: Evolution display -->

# SECTION: Evolution display

## FIT EVOLUTION: {COMPANY}, {N rounds completed}

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


