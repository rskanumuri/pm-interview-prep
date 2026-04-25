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

This system has 26 AI-powered commands for every stage of your PM interview journey —
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

#### Phase 4 — First Fit Check

Ask:
```
Last question: paste a JD for a role you're excited about — or name the company + role.

I'll score how you fit, find the biggest gap, and give you the 90-second answer to deliver if it comes up. (Takes 2-3 quick clarifications. Or say 'skip' to do this later.)
```

This phase chains three skills inline. Only the third one's output is shown to the user. The first two run silently to build the inputs the third one needs.

**If they paste a JD (the wow path):**

1. Parse `{company}` and `{role}` from the JD. Sanitize `role_slug` per the Multi-Role File Keying convention.
2. Add the company to `interview_prep/companies.json`. Save the JD to `sources/{company}/jd_{role_slug}.md`.
3. **Step A (silent — no console output):** Run the full `/company-prep {company} {role}` logic inline:
   - WebSearch for company overview, products, competitors, recent news
   - Create `interview_prep/insights/{company}.md`
   - Create `interview_prep/scripts/{company}_cheat_sheet.md`
   - Create `interview_prep/rubrics/{company}.md`
   - Append entry to `interview_prep/scripts/why_company_role_scripts.md`
4. **Step B (silent — no console output):** Run the full `/eval` logic on the JD inline:
   - Produce `interview_prep/evaluations/{company}_{role_slug}_eval.json`
   - This populates the JD requirement mapping that `/fit-check` consumes
5. **Step C (display — this is the wow):** Run the full `/fit-check {company} {role}` logic inline. Display ONLY:

   ```
   FIT CHECK — {Company} / {Role}
   ───────────────────────────────

   {VERDICT} — {avg_score}/5
   (e.g. STRONG FIT — 4.2/5, or FIT WITH GAPS — 3.4/5)

   Top gaps to address:
     1. {dimension_name} — {severity}/5  ({1-line description})
     2. {dimension_name} — {severity}/5  ({1-line description})

   Gap-bridging answer for #1 (60-90 sec, ready to deliver):
   ─────────────────────────────────────────────────────────
   {full gap-bridging script from /fit-check output}

   Built your full prep package too:
     interview_prep/scripts/{company}_cheat_sheet.md
     interview_prep/insights/{company}.md
     interview_prep/rubrics/{company}.md
     interview_prep/scripts/{company}_gap_bridging.md

   Numbers will sharpen after Phase 5 seeds your story bank.
   ```

   This is the live demo — the user watches real research happen, then reads a personalized fit assessment that references their resume from Phase 2.

**If they name a company without a JD:**

1. Reprompt once: "Paste even one paragraph of the role description — I need it to score your fit. Or skip and I'll just build the research package."
2. If they paste anything role-shaped, treat it as a JD and run the wow path above.
3. If they decline, fall back to `/company-prep {company}` only (research-only path):
   - Run Step A from above
   - Skip Step B and Step C
   - Note in the closing line: "I built the research package. Once you have a JD, run `/fit-check {company}` to get the personalized fit score and gap-bridging answer."

**If they say "skip":**
- That's fine. Move to Phase 5.

**Notes for the assistant executing Phase 4:**

- The Role Taxonomy Pass inside `/fit-check` Step 0 may ask the user 1–3 clarifying questions (Builder vs Owner, Craft vs Domain, Day-30 deliverable). This is expected; do not skip it.
- `/fit-check` reads `story_bank.json` for canonical numbers, but Phase 5 has not seeded it yet at this point. Use resume-extracted numbers; the displayed footer notes that Phase 5 will sharpen them.
- Suppress all intermediate console output from Steps A and B. The user sees exactly one block of output at the end (the FIT CHECK display).

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
{if Phase 4 wow path completed: | **{Company}** | Fit Check Complete ({fit_score}/5) | Run /interview-prep {company} recruiter | Top gap: {top_gap}. Gap-bridging answer ready. |}
{if Phase 4 company-only fallback: | **{Company}** | Research Complete | Run /fit-check {company} once JD is available | Cheat sheet ready; fit not yet scored. |}

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
- **Match the hero to the audience (multi-interviewer loops).** Same story, same facts, different emphasis per interviewer function. Engineering interviewer → their team is the hero (what goal, constraints, and product decisions you gave them; they built from there). Design interviewer → their process is the hero (how you respected their craft). HM → their priorities reflected back. If two versions of the same story sound identical across interviewer functions, the story is interviewer-blind and loses advocate votes in the debrief. Before a loop, rehearse one story rotated across each interviewer's function; if the rotations sound the same, fix it.

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

### Cost Optimization: Agent Model Routing

- **Background research agents** → use `model: "sonnet"` (web search, company research, competitive analysis)
- **Scaffold/file generation agents** → use `model: "sonnet"` (company-prep scaffolding, process-sources)
- **Keep Opus for**: scoring, debrief analysis, interview coaching, fit-check judgment, story integrity, drill evaluation
- Rule of thumb: if the agent is gathering/organizing info, use Sonnet. If it's making judgment calls about fit or performance, keep Opus.

### Skill Nudges

When asked to do something a skill handles, nudge with `(tip: /skill-name does this)`:
- "save to git" → `/save-push` | "pressure test" → `/steelman` | "paste transcript" → `/debrief-live`
- "show TMAY" → `/tmay` | "drill me" → `/drill-rapid` | "check numbers" → `/story-check`
- "look up company" → `/research` | "plan today" → `/battle-plan` | "fit for role" → `/fit-check`
- "debrief interview" → `/debrief` | "prep progress" → `/battle-plan progress`
- "research X" (without /command) → ask "Want it timed? (default: 10 min)" then route to `/timed-research`
- "show stories" / "story bank" → `/story-bank` | "story angles" → `/story-bank angles`
- "import stories" / "onboard prep" / "bulk add stories" → `/story-bank import`
- "prep for company" / "company prep" → `/company-prep` | "build prep for interview" / "stage prep" → `/interview-prep`
- "who am I up against" / "competitor for this role" → `/phantom` | "map stories to company" → `/story-map`
- "show pipeline" / "interview dashboard" → `/pipeline` | "mock interview" / "practice PM question" → `/pm-practice`
- "pre-interview check" / "am I ready" → `/prep-check`

### Working Style Preferences

- Be direct. Don't over-explain.
- Don't spawn research agents for things that can be reviewed inline — do it directly.
- When creating content, write it fully. Don't give summaries and ask "should I write it?"
- Never invent story details. If you don't have the data, say so.
- When dates/numbers are corrected, update ALL files, not just the one being discussed.
- When told "yes, do it" — execute immediately, don't ask clarifying questions.

### Career Learning Hooks

- After any `/debrief` or `/debrief-live`, automatically compare this round's patterns against `interview_prep/interview_lessons.md` and PROPOSE specific updates (extract from debrief data, show the proposed change, don't ask the user to generate).
- When archiving a rejected company, read all debriefs for that company, cross-reference with `interview_prep/career_takeaways.md`, and PROPOSE a specific career takeaway. User reviews and approves.
- When archiving a rejected company, if `{company}_phantom.md` exists, update it with post-mortem: "The candidate who got this job probably had X." Final version becomes a learning artifact.
- Living docs: `interview_prep/career_takeaways.md` (career wisdom) + `interview_prep/interview_lessons.md` (learned vs still learning)

### Outreach Drafting Discipline

- Before drafting any cold email, "I'm Interested" note, or LinkedIn DM, confirm the brief in ONE upfront exchange if unclear: voice (application not essay), length (~60-80 words), anchor = product opinion not marketing critique, ranking-trap scan (never lead with their number when ours is smaller). See `memory/feedback_outreach_brief_discipline.md`.
- Poster visibility ≠ HM. When a role has a visible poster or talent contact, default framing is "poster, possibly HM, could be a Director on their team" until explicit evidence says otherwise. See `memory/feedback_outreach_hm_signals.md`.
- When two similar-spelling names appear for the same company (e.g., Sam vs Saam), pause and disambiguate with ONE question before drafting anything named.
- Product opinion = what they should DO (build, ship, change). Marketing critique = commenting on what their claims SAY (accuracy-percent claims, "industry-leading"). Never anchor outreach on the latter.
- For high-stakes outreach (land an interview, bypass a closed funnel, warm a cold HM), pair the note with a built artifact: a clickable prototype, a one-page teardown, a short analysis. Words alone don't signal builder; the artifact does. The artifact choice is bespoke per opportunity, not formulaic. High-stakes outreach rewards a build matched to the role, not a templated drop.

### File Hygiene

- One battle plan at a time. Archive old ones immediately.
- Company-specific content stays in company folders, not scattered.
- When a company is done (rejected/accepted), move their files to `sources/<company>/` promptly.
- Don't create new files when updating existing ones would work.
- Every intel file in `sources/<company>/` (podcast notes, call summaries, DM logs, emails) opens with a **Source:** line naming the channel (public podcast + episode/date, private call + attendees, LinkedIn DM thread, etc.). Affects how we reference it in follow-ups.

### Multi-Role File Keying
- When a company has multiple roles being tracked, files key on `{company}_{role_slug}` instead of `{company}` alone so two roles at one company don't collide.
- `role_slug` = role string lowercased, non-alphanumeric → underscores (e.g., "Senior PM, Data Governance" → `senior_pm_data_governance`).
- Commands `/company-prep`, `/fit-check`, `/phantom` accept an optional `<role>` arg. When provided, they write and read role-keyed files. When omitted, they fall back to `{company}_*` (legacy single-role behavior, preserves active pipelines).
- Read order on lookups: try `{company}_{role_slug}_*` first if role is provided, fall back to `{company}_*` if role-keyed files don't exist.
- Existing single-role companies keep their current filenames. Migrate only if/when a second role at that company shows up.

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
  {if Phase 4 company prepped:}
  interview_prep/scripts/{co}_cheat_sheet.md
  interview_prep/insights/{co}.md
  interview_prep/rubrics/{co}.md
  {if Phase 4 wow path completed:}
  interview_prep/evaluations/{co}_{role_slug}_eval.json
  interview_prep/scripts/{co}_gap_bridging.md
  sources/{co}/jd_{role_slug}.md

  WHAT YOU CAN DO NEXT
  ────────────────────
  /fit-check <company>      Score your fit for another role + get gap-bridging answers
  /company-prep <name>      Build full prep for another company
  /pm-practice <company>    Practice interview questions with scoring
  /tmay <company>           Practice your Tell Me About Yourself
  /scan                     Find PM roles matching your profile
  /pipeline                 See your interview pipeline dashboard
  /story-bank               Browse and manage your STAR stories
  /story-bank import        Bulk-import stories you already have prepped
  /battle-plan              Plan your daily prep schedule

  Tip: Once you have your next JD, run /fit-check on it.
       Same wow you just saw, for any role you're considering.
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
3. Run a real `/company-prep` on a well-known public company (e.g., Stripe or Notion) so the user sees actual research happening, then run `/fit-check` against a representative JD for that company (use a real public PM JD if findable, otherwise a hard-coded synthetic one in this file) so the user also sees the personalized fit score + gap-bridging answer wow
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
- **Phase 4 (fit check) is the wow moment.** The personalized fit score + gap-bridging answer is the surprise — not the research package. If the user pastes a JD, run the full chain (company-prep silent → eval silent → fit-check displayed). Research alone is not the wow; tying the user's resume from Phase 2 to a tailored interview answer is.
- **Every file written must be compatible with all 25 other skills.** Follow exact schemas.
- **If anything fails, degrade gracefully.** Skip the phase, note what's missing, keep going.
- **End with clear next steps.** Don't leave the user wondering what to do.
