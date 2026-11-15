# Display layouts and templates for /eval

Kept outside `.claude/commands/eval.md` to keep the skill short enough to survive a context compaction. The skill points here; read the section you need when rendering. Sample values in these layouts (names, scores, dates, counts) are placeholders, not data: never copy one into output. Headings shown with a dash are written with a colon in generated files (`interview_prep/reference/skills_core.md` section 7).

---

<!-- section: Full evaluation display -->

# SECTION: Full evaluation display

## EVAL: {COMPANY}, {Role Title}

**VERDICT:** {STRONG FIT / FIT WITH GAPS / STRETCH / PASS} ({X.X}/5.0)
**Archetypes:** {matched archetypes} ({N}/{total} overlap)

---

### Block A: Role Summary, Grade: {X}

- **Company:** {name}
- **Role:** {title}
- **Level:** {detected} | **Location:** {loc}
- **Scope:** {scope} | **H1B gate:** {SPONSORS/UNKNOWN/BLOCKED} | **Title gate:** {PASS/FAIL_TITLE}
- **TL;DR:** {one-liner}

---

### Block B: Resume Match, Grade: {X}

| Requirement | Score | Evidence |
|-------------|-------|----------|
| {requirement} | {X}/5 | {proof with numbers} |
| {requirement} | {X}/5 | {proof or gap} |

**Gaps:** {list of requirements scoring 2 or below}

---

### Block C: Level & Comp Strategy, Grade: {X}

- **Detected level:** {level}
- **Comp estimate:** {range} | **Target:** {from CLAUDE.md}
- {strategy note}

---

### Block D: Comp Research, Grade: {X}

| Source | Data | Confidence |
|--------|------|------------|
| {source} | {data} | {level} |

---

### Block E: Application Strategy, Grade: {X}

**Cover letter angles:**
1. {angle with proof point}
2. {angle with proof point}
3. {angle with proof point}

**Outreach:** "{3-sentence LinkedIn message}"
**Key differentiator:** {what the user brings that others don't}

---

### Block F: Interview Plan, Grade: {X}

**Predicted format:** {stages}

**Key stories:**
1. {story name}: maps to {JD requirement}
2. {story name}: maps to {JD requirement}
3. {story name}: maps to {JD requirement}
4. {story name}: maps to {JD requirement}
5. {story name}: maps to {JD requirement}

**Gap preview:**
- {gap}: {severity}, {bridge available? Y/N}

---

### Block G: HM Lens (not scored), MSN confidence {N}/10

**Trigger:** {why the req is open now} | **HM wins if:** {promotion outcome} | **HM fears:** {feared failure}

| Must / Should | Tier | You | Evidence or gap |
|---------------|------|-----|-----------------|
| M1 {must} | {Stated/Inferred-strong} | {X}/5 | {proof or HIDDEN-MUST GAP + verify question} |
| S1 {should} | {tier} | {X}/5 | {proof} |

**Unwritten deal-breakers:** {list or none}
**HM lens shifts the read:** {one line, or "no, JD matches HM need"}

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


