# Setup — First-Time Setup Wizard

One-command onboarding for new users. Gets you from fresh clone to fully configured in ~5 minutes — no manual file editing required.

## Data Files

### Read
- `interview_prep/progress.json` (detect fresh state)
- `CLAUDE.md` (detect sentinel)
- `interview_prep/story_bank.json` (check if empty)
- `interview_prep/companies.json` (check registry)

### Write
- `sources/{name}/resume.txt`
- `interview_prep/progress.json`
- `CLAUDE.md`
- `interview_prep/story_bank.json`
- `interview_prep/story_bank.md`
- `interview_prep/companies.json` (if company prep runs)

## Commands

Parse `$ARGUMENTS` to determine the command:

### (no args) — Full Setup Wizard

#### Phase 0 — Fresh State Detection

1. Read `interview_prep/progress.json`
2. Read `CLAUDE.md` — look for `<!-- INIT_STATUS: unconfigured -->` sentinel

**If already configured** (active_user is NOT "your_name" AND sentinel says "configured" or is absent):
```
This workspace is already configured for {name}.

- /setup reset  — Start over (preserves resume and company research)
- /setup status — Show current configuration
- /setup --demo — Explore with sample data
```
Stop here.

**If fresh state**, proceed with the wizard:

```
WELCOME TO PM INTERVIEW PREP

This system has 24 AI-powered commands for every stage of your PM interview journey —
from job discovery through post-interview debrief.

Let's get you set up. This takes about 5 minutes.
I'll ask a few questions, read your resume, and build your profile automatically.
```

---

#### Phase 1 — Identity

Ask these two questions:

1. "What's your first name?"
2. "What's your full name as it appears on your resume?" (e.g., "Jane Smith")

**Actions:**
- Derive folder name: lowercase first name, no spaces (e.g., "jane")
- Create directory: `sources/{folder_name}/`
- Update `interview_prep/progress.json`:
  - Set `active_user` to `{folder_name}`
  - Set `start_date` to today's date (YYYY-MM-DD)

---

#### Phase 2 — Resume Ingestion

Ask:
```
Now I need your resume. Three options:

1. Paste it — copy your resume text and paste it right here
2. File path — if you already dropped a file in the repo, tell me where
3. Skip — I'll set up a placeholder; you can add it later
```

**Handle each input type:**

| Input | Detection | Action |
|-------|-----------|--------|
| Pasted text with "Experience", company names, dates | Resume detected | Save to `sources/{name}/resume.txt`, proceed to extraction |
| Pasted text with "Requirements", "Qualifications", "About the role" | JD detected | Say: "That looks like a job description, not a resume! I'll save it for later." Save to `sources/inbox/jd_import.md`. Re-ask for resume. |
| A file path that exists in the repo | File path | Read the file. If it's a PDF, read it. Copy/save content to `sources/{name}/resume.txt`. Proceed to extraction. |
| "skip" or similar | Skip | Create `sources/{name}/resume.txt` with placeholder text: "Add your resume here. Then run /setup again or manually update CLAUDE.md." Set `resume_skipped = true` flag. |

**Resume Extraction (only if resume was provided):**

Analyze the resume and extract:

1. **Career thesis draft** — Look at the arc of their career. Propose a one-sentence thesis.
   ```
   Based on your resume, here's a draft career thesis:

   **"[Proposed thesis]"**

   Does that resonate? Feel free to rephrase, or just say 'yes' to keep it.
   ```

2. **Key numbers** — Find 4-6 quantified impact metrics from the resume.
   ```
   I found these impact numbers in your resume:

   - [metric 1]
   - [metric 2]
   - [metric 3]
   - [metric 4]

   These become your "canonical numbers" — used in TMAY and stories.
   Any corrections or additions? (or 'looks good')
   ```

3. **STAR story candidates** — Identify 3-5 accomplishments that map to STAR format. For each, draft: situation (1 line), task (1 line), action (1 line), result (with number). Don't show these yet — save for Phase 5.

4. **Target archetypes** — From the resume, detect which PM archetypes fit.
   ```
   Your resume maps strongest to these role types:

   - [Archetype 1] (proof: [which experience])
   - [Archetype 2] (proof: [which experience])
   - [Archetype 3] (proof: [which experience])

   Sound right? Add or remove any.
   ```

**If resume was skipped**, ask these manually instead:
- "In one sentence, what's your career thesis — the thread that connects your work?"
- "What are your 3-5 biggest impact numbers? (e.g., '$50M ARR', '10x improvement', '500K users')"
- "What PM role types are you strongest for? (e.g., 'Enterprise Platform PM', 'AI/ML PM', 'Growth PM')"

---

#### Phase 3 — Job Search Config

Ask these questions (present smart defaults if resume was analyzed):

1. "What's your base salary target?" (suggest default based on seniority detected)
2. "Total comp target?" (suggest base × 1.4)
3. "Do you need visa sponsorship (H1B)?" (yes/no)
4. "Location preferences?" (free text — e.g., "Bay Area, remote OK, open to NYC")
5. "Any deal-breakers?" (optional — e.g., "no companies under 50 people, no crypto")

---

#### Phase 4 — First Company (The Wow Moment)

Ask:
```
Last question: What company are you most excited about right now?

I'll build a full prep package for them — research, cheat sheet, scoring rubric.
You can watch it happen live. (Or say 'skip' to do this later.)
```

**If they name a company:**
1. Add the company to `interview_prep/companies.json`
2. Run the full `/company-prep` logic inline:
   - WebSearch for company overview, products, competitors, recent news
   - Create `interview_prep/insights/{company}.md`
   - Create `interview_prep/scripts/{company}_cheat_sheet.md`
   - Create `interview_prep/rubrics/{company}.md`
   - Generate TMAY tailored to this company
   - Generate "Why {Company}?" script
3. This is the live demo — the user watches real research happening in real-time

**If they paste a JD instead of a company name:**
- Extract company name from JD
- Save JD to `sources/{company}/jd.md`
- Run `/eval` logic on the JD (quick score)
- Then run `/company-prep` logic
- Show: "Score: X/5 — here's the full breakdown, plus I built your prep package."

**If they say "skip":**
- That's fine. Move to Phase 5.

---

#### Phase 5 — Story Bank Seeding

**Only runs if resume was provided in Phase 2.**

1. Take the 3-5 STAR story candidates extracted in Phase 2
2. For each, create a full entry in `interview_prep/story_bank.json`:
   ```json
   {
     "id": "{snake_case_name}",
     "title": "{Story Title}",
     "product": "{Product/Project}",
     "company": "{Company}",
     "year": "{Year}",
     "themes": ["{theme1}", "{theme2}"],
     "one_liner": "{One sentence summary with key metric}",
     "situation": "{Extracted from resume}",
     "task": "{Extracted from resume}",
     "action": "{Extracted from resume}",
     "result": "{Extracted from resume, with numbers}",
     "key_numbers": { "{metric_name}": "{value}" },
     "best_for": ["{question_type1}", "{question_type2}"],
     "company_angles": {},
     "performance": { "status": "ready", "times_told": 0 }
   }
   ```
3. If Phase 4 ran, add a `company_angles` entry for that company in each relevant story
4. Update `story_bank.json` metadata (total_stories, last_updated)
5. Regenerate `interview_prep/story_bank.md` from the JSON

Display:
```
STORY BANK SEEDED — {N} stories

| # | Story | Key Number | Status |
|---|-------|------------|--------|
| 1 | {title} | {number} | ready |
| 2 | {title} | {number} | ready |
| 3 | {title} | {number} | ready |

These are starter versions extracted from your resume.
They'll get richer as you practice. Run /story-bank anytime to manage them.
```

---

#### Phase 6 — CLAUDE.md Assembly

Write the complete CLAUDE.md by assembling all collected data. Use this template:

```markdown
<!-- INIT_STATUS: configured -->
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

PM interview preparation workspace for {full_name}.

---

## Active Pipeline

### Active Interviews

| Company | Stage | Next Step | Status |
|---------|-------|-----------|--------|
{if Phase 4 company exists: | **{Company}** | Research Complete | Run /interview-prep {company} recruiter | Cheat sheet ready. |}

### Career Thesis

**"{career_thesis}"**

### Key Numbers (Use in Stories)

{bullet list of confirmed canonical numbers}

---

## Job Search Config

### Comp Targets

Base: {base}+ | Total: {total}+{if visa: | Must sponsor H1B}

### Location

{location_preferences}

### Target Archetypes

{bullet list of archetypes with proof points}

### Application Preferences

- {visa preference if applicable}
- Exclude "project manager" and "program manager" titles
- Score threshold: only pursue roles scoring 3.0+ on /eval
{any deal-breakers}

### Top-of-Funnel Skills

- "evaluate role" / "check this JD" → `/eval`
- "find roles" / "scan jobs" → `/scan`
- "tailor resume" / "make CV" → `/cv-gen`
- "full pipeline" / "process this JD" → `/auto-pipe`
- "fill application" → `/apply`

---

## Standing Workflow Rules

### Transcript Handling

- **ALWAYS check `sources/<company>/` for saved transcripts BEFORE calling Granola MCP.**
- Transcripts are saved locally after first pull to avoid repeat token costs.
- Saved transcripts live in `sources/<company>/<interviewer>_<type>_transcript_<date>.md`
- Only call Granola if the transcript doesn't exist locally yet.
- **Every `/debrief` and `/debrief-live` MUST save the full verbatim transcript locally** before analysis.
- **Always save FULL transcripts. No summaries.** The raw text is the source of truth.

### Git Behavior

- After ANY file write during prep, offer to save and push.
- "Save everything" means: `git add` changed files → commit → push to remote. Always.
- Never leave untracked new files behind.
- Use `/save-push` skill when available.

### Story Integrity — Canonical Numbers

{for each confirmed number:}
- **{Product/Project}**: {metric and context}. {any disambiguation notes}.
- Run `/story-check` before interviews to catch drift.

### Purged Stories — NEVER USE

{empty if none provided, or user-specified entries}

### Interview Answer Format

- First line MUST directly answer the question asked. No preamble.
- Always include year and context in openers (e.g., "In 2021, during X launch...").
- Two-layer format: Layer 1 = 2-min opener, Layer 2 = deep follow-up details.
- Show the prepped answer FIRST before practice. Read first, then deliver.
- Score on /10 scale.

### Story Bank Sync

- **Canonical story index**: `interview_prep/story_bank.json` + `interview_prep/story_bank.md`
- Before ending any conversation where story-related files were created or modified, offer: "Run `/story-bank sync`?"
- After any `/debrief`, `/debrief-live`, `/drill-rapid`, or `/pm-practice` session, offer: "Update story bank with this session's data?"
- When you tell a story differently (new framing, new bridge), detect and offer to add as a new angle in `story_bank.json`
- `story_bank.md` is always auto-generated from JSON — never hand-edit it

### Timed Agents

- When research is requested without using `/timed-research`, ask: "Want it timed? (default: 10 min)"
- All background research agents MUST use the timed-research pattern
- Never launch untimed background agents for research tasks

### Skill Nudges

When asked to do something a skill handles, nudge with `(tip: /skill-name does this)`:
- "save to git" → `/save-push` | "pressure test" → `/steelman` | "paste transcript" → `/debrief-live`
- "show TMAY" → `/tmay` | "drill me" → `/drill-rapid` | "check numbers" → `/story-check`
- "look up company" → `/research` | "plan today" → `/battle-plan` | "fit for role" → `/fit-check`
- "debrief interview" → `/debrief` | "prep progress" → `/battle-plan progress`
- "research X" (without /command) → ask "Want it timed? (default: 10 min)" then route to `/timed-research`
- "show stories" / "story bank" → `/story-bank` | "story angles" → `/story-bank angles`

### Working Style Preferences

- Be direct. Don't over-explain.
- Don't spawn research agents for things that can be reviewed inline — do it directly.
- When creating content, write it fully. Don't give summaries and ask "should I write it?"
- Never invent story details. If you don't have the data, say so.
- When dates/numbers are corrected, update ALL files, not just the one being discussed.
- When told "yes, do it" — execute immediately, don't ask clarifying questions.

### File Hygiene

- One battle plan at a time. Archive old ones immediately.
- Company-specific content stays in company folders, not scattered.
- When a company is done (rejected/accepted), move their files to `sources/<company>/` promptly.
- Don't create new files when updating existing ones would work.

---

### Pre-Interview Rules

1. **Lead with business impact, not technology.**
2. **Never introduce a story with what you lack.**
3. **Never frame a current/recent role as a consolation prize.**
4. **"Can AI make it faster?" test** — if a generic AI answer could replace yours, be more specific.
5. **End with offer.**

---

### Key Frameworks

**Product Sense/Design:** Mission & market → Target users → User journeys & pain points → Creative solutions
**Five Skills:** Information gathering, Structured thinking, Prioritization, User empathy, Creative brainstorming

---

## Scoring

- Each answer: 2 universal scores (Delivery 1-5, Company Fit 1-5) + 3-4 format-specific scores (count 2x)
- Automatic -1 penalty for violating any pre-interview rule
- Flag for review: any question scoring below 3.0 overall
- Rubrics: `interview_prep/rubric.md` (master), `interview_prep/rubrics/` (company-specific)

---

## Inbox

- `sources/inbox/` — Drop anything here, auto-classified by `/process-sources`
```

---

#### Phase 7 — Wrap-Up & Orientation

Display:

```
SETUP COMPLETE ✓

Here's what I built for you:

  FILES CREATED
  ─────────────
  sources/{name}/resume.txt         Your resume (source of truth)
  CLAUDE.md                         Your personalized brain file
  interview_prep/story_bank.json    {N} stories seeded from resume
  interview_prep/story_bank.md      Scannable story index
  {if company prepped:}
  interview_prep/scripts/{co}_cheat_sheet.md
  interview_prep/insights/{co}.md
  interview_prep/rubrics/{co}.md

  WHAT YOU CAN DO NEXT
  ────────────────────
  /eval <paste a JD>        Score a job description — should I apply?
  /company-prep <name>      Build full prep for another company
  /pm-practice <company>    Practice interview questions with scoring
  /tmay <company>           Practice your Tell Me About Yourself
  /scan                     Find PM roles matching your profile
  /pipeline                 See your interview pipeline dashboard
  /story-bank               Browse and manage your STAR stories
  /battle-plan              Plan your daily prep schedule

  Tip: Start with /eval on a job you're excited about.
       It takes 2 minutes and shows you how the system thinks.
```

Then ask: "Want me to save everything to git? (`/save-push`)"

---

### `--demo` — Demo Mode

When invoked with `/setup --demo`:

1. Skip all questions
2. Create a demo profile:
   - Name: "Alex Demo", folder: `sources/alex_demo/`
   - Resume: Synthetic PM resume (realistic but clearly fake)
   - Career thesis: "I build developer tools that engineers actually use."
   - Key numbers: Clearly labeled as demo data
   - 3 pre-written STAR stories
3. Run a real `/company-prep` on a well-known public company (e.g., Stripe or Notion) so the user sees actual research happening
4. Mark all created files with `<!-- DEMO DATA — run /setup reset then /setup to replace with your real profile -->` at the top
5. At the end: "This was demo mode with sample data. When you're ready: `/setup reset` then `/setup` with your real resume."

---

### `reset` — Reset to Fresh State

1. Confirm: "This will reset your CLAUDE.md, story bank, and progress tracking. Your resume and company research files will be preserved. Continue? (yes/no)"
2. If yes:
   - Rewrite CLAUDE.md to the unconfigured template (with sentinel)
   - Reset `progress.json` to: `{ "active_user": "your_name", "start_date": null, ... }`
   - Clear `story_bank.json`: keep structure, empty `stories`, `canonical_numbers`, `purged_stories`
   - Clear `story_bank.md`
   - Do NOT delete `sources/{name}/` (preserve resume)
   - Do NOT delete company research files
3. Confirm: "Reset complete. Run `/setup` to set up again."

---

### `status` — Show Current Configuration

Read all config files and display:

```
CONFIGURATION STATUS

  User:           {name} (sources/{folder}/)
  Resume:         {exists / missing}
  Career Thesis:  {thesis or "not set"}
  Key Numbers:    {N} canonical metrics
  Stories:        {N} in story bank
  Companies:      {N} in registry
  Pipeline:       {N} active interviews
  Setup Date:     {date}
```

---

## Resume Analysis Guidelines

When extracting from a resume:

**Career thesis**: Look for the career arc — what kind of problems do they solve? What's the common thread? Draft a thesis in the form: "I [verb] [what] that [impact]." Keep it under 15 words.

**Key numbers**: Extract metrics that have:
- Dollar amounts ($XM ARR, $XM revenue)
- Percentage improvements (X% → Y%)
- Scale numbers (X users, X countries, X products)
- Time improvements (X weeks → Y weeks)
- Only include numbers the user can confidently defend in an interview

**STAR stories**: Look for resume bullets with:
- A clear before/after or problem/solution pattern
- Quantified results
- Individual ownership signal ("Led", "Designed", "Drove", not "Participated")
- Cross-functional or high-stakes context

**Target archetypes**: Map experience to standard PM archetypes:
- Enterprise Platform PM (if enterprise, B2B, platform experience)
- AI/ML Platform PM (if AI, ML, data platform experience)
- Growth PM (if conversion, retention, experimentation experience)
- Developer Tools PM (if APIs, SDKs, developer experience)
- Consumer PM (if B2C, mobile, social experience)
- Infra/Cloud PM (if infrastructure, cloud, DevOps experience)
- Fintech PM (if payments, banking, financial products experience)

---

## Error Handling

| Scenario | Detection | Response |
|----------|-----------|----------|
| Resume is a JD | "Requirements", "Qualifications", "About the role" without "Experience" section | "That looks like a job description. I'll save it for later." Save to inbox, re-ask. |
| Resume very short (<200 words) | Word count | "This seems brief — is this your full resume? I'll work with what's here." Proceed. |
| Resume is PDF/DOCX at a file path | Extension check | Read with Read tool (supports PDFs). Extract text. |
| Company not found | WebSearch returns thin results | "Couldn't find much about {company}. Is the name right? If it's a startup, tell me what they do." |
| progress.json missing/corrupted | File read error or JSON parse failure | Recreate from template. |
| User runs /setup after configuring | Sentinel check | Show "already configured" message with options. |
| Node.js not installed | Only matters for PDF generation | Note it in wrap-up: "Install Node.js + `cd tools && npm install` for PDF resume generation." |

---

## Key Rules

- **This skill is the FIRST IMPRESSION.** Make it smooth, fast, and impressive.
- **Never ask more than 2 questions at a time.** Keep the conversation flowing.
- **Show extracted data for confirmation, don't make users type everything.** The resume does the heavy lifting.
- **Phase 4 (company prep) is the wow moment.** If the user gives a company, make this step shine with real research.
- **Every file written must be compatible with all 24 other skills.** Follow exact schemas.
- **If anything fails, degrade gracefully.** Skip the phase, note what's missing, keep going.
- **End with clear next steps.** Don't leave the user wondering what to do.
