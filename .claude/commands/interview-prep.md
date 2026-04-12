# Interview Prep — Stage-Aware Prep Builder

On-demand interview preparation that scales with the interview stage. Checks Granola transcripts for prior round intel, builds what's missing, and ensures every interview has the right level of prep.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

- Companies Registry: `interview_prep/companies.json`
- Progress: `interview_prep/progress.json`
- Cheat Sheets: `interview_prep/scripts/{company}_cheat_sheet.md`
- Insights: `interview_prep/insights/{company}.md`
- Rubrics: `interview_prep/rubrics/{company}.md`
- Answer Scripts: `interview_prep/scripts/{company}_answer_scripts_*.md`
- Research: `interview_prep/research/`
- CLAUDE.md: `CLAUDE.md` (project root)

## Multi-Role File Keying

When reading/writing company-keyed files, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". This command accepts an optional `<role>` arg; when provided, use `{company}_{role_slug}` keys, else fall back to `{company}` (legacy single-role). Read-order on lookups: try role-keyed first, fall back to company-only.



Parse `$ARGUMENTS` to determine the command:

### `<company> <stage> [interviewer(s)]` — Build Stage-Appropriate Prep

**Stages:** `recruiter`, `hm`, `loop`, `final`

The skill builds CUMULATIVE prep — each stage includes everything from prior stages plus new deliverables.

---

## Stage 1: Recruiter Screen (`/interview-prep <company> recruiter`)

**Check what exists first.** If `/company-prep` was already run, most of this exists. Only build what's missing.

### Required Deliverables:
1. **Cheat sheet** — if missing, run `/company-prep` logic
2. **TMAY** — company-specific, 60 sec, numbers in first 15 sec
3. **Why Company** — 3 specific beats (not generic "AI-first, collaborative, customer-first")
4. **Extraction goals** — what to learn from this call (HM identity, team size, process, visa, comp, timeline)
5. **Recruiter Q&A** — 5 likely questions with scripted answers

### Granola Check:
- Query Granola for any prior meetings with this company
- If found: extract intel and incorporate into prep

### Output:
- Update cheat sheet with any missing sections
- Report: "Recruiter prep ready. Here's what to extract from the call: [list]"

---

## Stage 2: HM Screen (`/interview-prep <company> hm <interviewer_name>`)

**4 mandatory deliverables. No exceptions.**

### Required Deliverables (in addition to Stage 1):

1. **Gap analysis** — research the company's product gaps
   - Search: company docs, changelog/release notes, G2/Gartner Peer Insights reviews, community forums
   - Focus on the team/area the role sits in, NOT the whole company
   - Output: 3-5 evidence-backed gaps with hypotheses
   - **Frame gaps as questions, not criticisms** — "I noticed X, is that a priority or sequenced behind Y?"
   - Write to: `interview_prep/research/{company}_enterprise_gaps.md`

2. **Domain glossary / Functional fluency guide** — sound like you belong
   - Vocabulary tables: tourist vs native phrasing for the role's domain
   - Operating rhythms: what the function's week/month/quarter looks like
   - Tools & systems the function lives in
   - Opinions you must have (a peer has POVs, not just frameworks)
   - Your experience reframed in their language
   - 10 phrases that signal you belong
   - Write to: `interview_prep/scripts/{company}_functional_fluency_guide.md`

3. **Problem-first play** — solve their problem live, don't recite resume
   - Scripted flip question: "What's the most urgent challenge you're trying to solve with this hire?"
   - Response paths: 4-6 likely answers the HM could give, each with a full scripted response using your experience
   - Steelman: what the HM would say to push back on each gap, with your response
   - Kill risks: 8-10 things that could fail in this interview, each with a specific fix

4. **Interviewer profile** — know who you're talking to
   - LinkedIn research: career trajectory, expertise, common ground
   - Public content: blog posts, talks, LinkedIn posts
   - Interview style prediction
   - Rapport hooks
   - Predicted questions (5-8)
   - Write to: `interview_prep/research/{company}_interviewer_profiles.md`

### Double-Change Assessment:
- Determine: is this a single change (company only) or double change (company + domain)?
- If double change: flag explicitly. Domain glossary becomes MORE critical.

### Company Rubric Check:
- Verify `interview_prep/rubrics/{company}.md` exists
- If not, create one before the HM screen

### Output:
- All 4 deliverables created/updated
- Report: "HM prep ready. 4 deliverables built. Key gap: [top gap]. Problem-first play: [scripted question]. Kill risks: [top 3]."

---

## Stage 3: Loop (`/interview-prep <company> loop <interviewer1> <interviewer2> ...`)

### Required Deliverables (in addition to Stages 1-2):

1. **Question bank** — 15-20 questions per interviewer
2. **Answer scripts per interviewer** — full scripted answers
3. **Pre-mortem** — every way this can fail
4. **All interviewer profiles** — one per interviewer
5. **Battle plan** — day-by-day schedule

### Output:
- All deliverables created
- Report: "Loop prep ready. [N] questions across [M] interviewers. Top 3 kill risks: [list]."

---

## Stage 4: Final (`/interview-prep <company> final [interviewer]`)

### Required Deliverables:
1. **Updated interviewer profile** for final round interviewer
2. **Tight answers** — 30-60 sec versions of key stories
3. **Questions to ask** — specific to this interviewer's role/level
4. **Review all prior round debriefs** — identify patterns
5. **One-page summary** of everything learned across all rounds

---

## Utility Commands

### `<company> status` — What's Prepped vs What's Missing
### `<company> gaps` — Quick Gap Analysis Only
### `<company> profile <name>` — Quick Interviewer Profile Only
### `<company> glossary` — Quick Domain Glossary Only

---

## Key Rules

### Always Do:
- **Check Granola first** — query for ALL meetings with this company before building anything
- **Check what exists** — don't rebuild what's already there. Update, don't overwrite.
- **Load the company rubric** — if it doesn't exist, create it
- **Assess single vs double change** — company + domain change needs 3x the glossary and gap analysis work
- **Frame gaps as questions** — "I noticed X, is that a priority?" NOT "your product is missing X"

### Never Do:
- **Never use generic dimensions** when a company rubric exists
- **Never build prep without checking Granola** for prior round transcripts
- **Never skip the gap analysis for HM screens** — it's mandatory
- **Never fake domain expertise** — use AI to DO domain work, not pretend you have experience you don't

### Insider Info Handling:
- If Granola transcripts or user-provided info contains insider intel:
  - Mark as **"DO NOT CITE IN INTERVIEWS"** in all prep docs
  - Use to INFORM answer framing, not to demonstrate knowledge

### Standing Rules (from CLAUDE.md):
- Lead with business impact, not technology
- Never introduce a story with what you lack
- First line MUST directly answer the question
- Two-layer format: Layer 1 = 2-min opener, Layer 2 = deep follow-up
- Score on company rubric dimensions, weighted correctly
