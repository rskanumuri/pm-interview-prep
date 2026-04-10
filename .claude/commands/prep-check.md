# Pre-Interview Readiness Briefing

Zero-write, read-only skill. Synthesizes all prep artifacts into a focused pre-interview briefing. Run this 30-60 minutes before an interview.

## Data Files (READ ONLY — this skill does NOT write to any files)

- Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, stories)
- Master Stories: `interview_prep/scripts/master_story_repository.md` (canonical story registry)
- Progress: `interview_prep/progress.json` (patterns_to_fix, flagged, red_flag_words, scores)
- Company Insights: `interview_prep/insights/{company}.md`
- Company Rubric: `interview_prep/rubrics/{company}.md`
- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Debriefs: `interview_prep/answers/{company}_*_debrief_*.md` (lessons from prior rounds)
- CLAUDE.md: `CLAUDE.md` (company context, interview schedule, pre-interview rules, canonical numbers)
- Personal Docs: `sources/{active_user}/` (performance kit, proof points)

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company>` — Full Readiness Briefing

Comprehensive 5-minute pre-interview briefing. Read all artifacts and synthesize.

**Steps:**

1. Read all data files listed above for the target company
2. Display the full briefing using **markdown headers, bold, and bullets — NEVER code blocks or fixed-width ASCII art**:

## PRE-INTERVIEW BRIEFING — {COMPANY}
**{Date} | {Time} | {Format} | {Interviewer}**

---

### Pre-Interview Rules
{Read from CLAUDE.md "Pre-Interview Rules" section. Display all rules listed there.}

---

### Your TMAY ({time} sec)
{Full TMAY from cheat sheet — read it aloud once before the call}

---

### Why {Company}? (30 sec)
{Why Company script from cheat sheet or why_company_role_scripts.md}

---

### Top 3 Stories — Ready to Deploy

**1. {Story name}** — {key number}
- Bridge: {one-line bridge to company}

**2. {Story name}** — {key number}
- Bridge: {one-line bridge}

**3. {Story name}** — {key number}
- Bridge: {one-line bridge}

**Backup:** {story name} (for follow-ups or unexpected angles)

---

### Locked Numbers
{Read from `story_bank.json` canonical_numbers AND/OR CLAUDE.md "Key Numbers" section. Display the user's canonical metrics.}

---

### Patterns to Watch (from practice)
- {pattern from progress.json patterns_to_fix — most relevant 3-4}
- {pattern}
- {pattern}

---

### Red Flag Words
- ~~{word}~~ → "{alternative}"
- ~~{word}~~ → "{alternative}"
(from progress.json red_flag_words)

---

### Lessons from Prior Rounds
{If debriefs exist for this company, pull key lessons}
{If no prior rounds, show "First round — no prior data"}

**From {interviewer} ({date}):**
- {lesson 1}
- {lesson 2}

---

### What They're Looking For
{From insights file — top 3-4 things this company evaluates}
{From rubric — the company-specific scoring dimensions}

---

### Known Gaps — Bridge Ready

**{gap name} ({severity})**
- Bridge: "{scripted bridge phrase}"

**{gap name} ({severity})**
- Bridge: "{bridge}"

---

### Questions to Ask Them
1. {from cheat sheet}
2. {from cheat sheet}
3. {from cheat sheet}
4. {from cheat sheet}

---

### Final Check
- [ ] Camera on, background clean
- [ ] Water nearby
- [ ] Cheat sheet printed/on second screen
- [ ] STAR sticky note on monitor
- [ ] Read TMAY aloud once
- [ ] Read Why {Company} aloud once
- [ ] Take 30-60 sec before answering — pick the RIGHT story

---

**{Career thesis from CLAUDE.md}**

### `<company> quick` — 60-Second Quick Card

Minimal briefing for when you have 1 minute before the call. Just the essentials.

**Steps:**
1. Read cheat sheet and progress.json only (speed over completeness)
2. Display using **markdown — NEVER code blocks**:

## QUICK CARD — {COMPANY}
**{format} | {interviewer}**

**TMAY:** {first sentence of TMAY}..."[career thesis hook for company]"

**3 Stories:**
1. {name} → {number}
2. {name} → {number}
3. {name} → {number}

**3 Numbers:** {top 3 canonical numbers from story_bank.json}

**2 Questions:**
1. {top question}
2. {second question}

**Watch:** {top pattern to fix} | {top red flag word to avoid}

**Rules:** {Summarize pre-interview rules from CLAUDE.md}

## Handling Missing Artifacts

If any artifact is missing, note it clearly but don't block the briefing:

**No cheat sheet found for {company}** — Run `/company-prep {company}` to create one. Using general prep data instead.

For missing artifacts, fall back to:
- No cheat sheet → use Why script from why_company_role_scripts.md + general TMAY
- No insights → use CLAUDE.md company section if present
- No rubric → skip "What They're Looking For" section
- No debriefs → show "First round — no prior data"
- No progress data → skip "Patterns to Watch" section

## Key Rules

- **READ ONLY** — this skill does NOT create or modify any files
- **Speed matters** — the user is about to walk into an interview, be fast
- **Prioritize actionable info** — don't dump everything, curate the most important items
- **Always include pre-interview rules** — they're the foundation
- **Always include red flag words** — these are the easiest mistakes to prevent
- **Prior round lessons are gold** — if debriefs exist, surface those lessons prominently
- **Career thesis appears at the bottom** as the closing anchor
- **If company is not in registry**, still try to provide a general briefing using CLAUDE.md
