---
description: "Build stage-aware prep (recruiter, hm, loop, final) with gap analysis, glossary, interviewer profiles, and answer scripts."
argument-hint: "<company> <recruiter|technical|hm|loop|final> [interviewer...] | <company> status"
---

# Interview Prep — Stage-Aware Prep Builder

On-demand interview preparation that scales with the interview stage. Checks saved transcripts (then Granola) for prior round intel, builds what's missing, and ensures every interview has the right level of prep.

## Rules that must hold (kept at the top because a context compaction keeps only the start of a skill)

- **Clock and schedule check first** (`interview_prep/reference/skills_core.md` §1).
- **Saved transcripts first, then Granola;** save new pulls verbatim. A missing connection never blocks the build.
- **Check what exists; update, don't overwrite.** Every file written carries `{company_key}` in its name, including files under `interview_prep/research/`.
- **Prepare for the question that gets asked:** recruiter and technical screens at technical companies often ask for a system walkthrough instead of a TMAY (Stage 1, deliverable 7). The story is chosen by the nouns in the question, result first.
- **Company rubric exists before any round;** prep focuses on the 2x dimensions.
- **Never fake domain expertise;** use AI to do domain work in deliverables. Frame product gaps as questions.
- **Insider intel is marked DO NOT CITE IN INTERVIEWS.**
- **Current-employer firewall:** prep writes the safe answer, not just a warning (Stage 1, deliverable 9).
- **Numbers and stories come from canon** (`skills_core.md` §5); first line of every scripted answer answers the question.
- **Research runs inline by default;** background agents only when the user asks.

## Active User

Rule: `interview_prep/reference/skills_core.md` §4. Read `progress.json` `active_user`; personal material comes only from `sources/{active_user}/` and `interview_prep/story_bank.json`.

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

Rule: `interview_prep/reference/skills_core.md` §3 (how `{company_key}` is formed, role-keyed lookup first, where closed-company files live). Accepts an optional `<role>` arg. Every file this skill writes carries `{company_key}` in its name, including files under `interview_prep/research/`.



Parse `$ARGUMENTS` to determine the command:

### `<company> <stage> [interviewer(s)]` — Build Stage-Appropriate Prep

**Stages:** `recruiter`, `technical`, `hm`, `loop`, `final`

The skill builds CUMULATIVE prep — each stage includes everything from prior stages plus new deliverables.

**Before any stage:** run the clock and schedule check in `interview_prep/reference/skills_core.md` §1.

---

## Stage 1: Recruiter Screen (`/interview-prep <company> recruiter`)

**Check what exists first.** If `/company-prep` was already run, most of this exists. Only build what's missing.

### Required Deliverables:
1. **Cheat sheet** — if missing, run `/company-prep` logic
2. **TMAY** — company-specific, 60 sec, numbers in first 15 sec
3. **Why Company** — 3 specific beats (not generic "AI-first, collaborative, customer-first")
4. **Extraction goals** — what to learn from this call (HM identity, team size, process, visa, comp, timeline)
5. **Recruiter Q&A** — 5 likely questions with scripted answers
6. **Phantom V1 (offer)** — offer `/phantom <company> [role]` (V1 from JD + company research); skip if a phantom already exists
7. **System walkthrough** (required when the role is AI, platform, infrastructure or otherwise technical; optional elsewhere). Recruiters at technical companies often skip the TMAY and ask "walk me through a complex system you built end to end". Prepare one 4-minute answer for the single story that best matches the nouns in the JD (LLM, agentic, platform, pricing engine, and so on), in this order:
   - Result in the first 30 seconds (the canonical number, worded per `canonical_provenance`)
   - Business problem
   - The layers or components, named
   - Three decisions with the trade-off for each
   - How quality was measured (evaluation, guardrails, human review)
   - What was unsolved or what the candidate would do differently
   - Result again, one sentence
   Rules: pick the story by fit to the question, not by size; scale proof from another job gets one sentence at the end; never open by listing what the story does not cover. If the story's underlying work is more than six months old, build or refresh its recall file first (`/drill-rapid recall <story>` builds it).
8. **Format-unknown fallback** — a recruiter screen can be a TMAY, a system walkthrough, or an AI-fluency question. The cheat sheet opens with a three-line "if they ask X, start with Y" card covering all three.
9. **Safe builder answer** (when the user is currently employed elsewhere) — a scripted answer to "how do you use AI tools day to day" that leads with work from the user's own repos and tools, and describes current-employer work in one neutral sentence with no internal tooling, team or deal detail. A warning line is not enough; write the answer.
10. **Application trail** (inbound roles) — if mail tools are connected, search for the original application or confirmation and which resume was sent; record what was found, or "no trail found", in the cheat sheet and add "which resume do you have?" to the questions list.

### Granola Check:
- Check `sources/<company>/` for saved transcripts first; query Granola only for meetings not saved locally (save new pulls there)
- If found: extract intel and incorporate into prep

### Output:
- Update cheat sheet with any missing sections
- Report: "Recruiter prep ready. Here's what to extract from the call: [list]"

---

## Stage 1.5: Technical or Peer Screen (`/interview-prep <company> technical <interviewer_name>`)

Some processes put a 30 to 45 minute screen with an engineer, TPM or peer PM between the recruiter and the hiring manager. It usually repeats the system-walkthrough question at more depth.

### Required Deliverables (in addition to Stage 1):
1. **System walkthrough, deep version** — the Stage 1 walkthrough plus a second layer for each of the three decisions (what was measured, what the alternative would have cost, who disagreed).
2. **Recall pass** — run the recall questions in the story's recall file out loud; every blank is either filled by the user or marked "I don't recall the exact figure".
3. **Source-versus-canon check** — list every place a primary document words a fact differently from `canonical_provenance` (ownership, dates, metric definitions) and write the one sentence the user will say if probed.
4. **Interviewer profile** — function decides the hero: for an engineer or TPM, the engineering team is the hero (goal, constraints and product decisions given to them).
5. **Five technical follow-ups** the interviewer is likely to ask, each with what the story can and cannot support.

### Output:
- Report: "Technical screen prep ready. Walkthrough: {story}. Open gaps: [list]."

---

## Stage 2: HM Screen (`/interview-prep <company> hm <interviewer_name>`)

**4 mandatory deliverables. No exceptions.**

### Required Deliverables (in addition to Stage 1):

0. **HM-lens MSN, updated to V2+**: read `interview_prep/evaluations/{company_key}_hm_msn.md` (build per `interview_prep/reference/hm_lens_msn_method.md` if missing) and run its Update step with the recruiter intel. Its Musts anchor the gap analysis focus, the problem-first play response paths, and the kill risks. Its HM synthesis (feared failure) seeds the "What is this interviewer afraid of" section. Its verify questions become candidate flip questions.

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
   - **What is this interviewer afraid of in this hire?** (MANDATORY section)
     - Every interviewer has a fear, and it's usually different from what they'll ask about.
     - HM fears: hiring the wrong person (reputational cost), hiring someone who can't ramp, hiring someone who won't challenge them enough, hiring someone who's a flight risk.
     - Skip-level fears: the HM's judgment being wrong, the role's scope being too narrow/broad, the candidate operating below the level.
     - Eng director fears: someone who ships specs but can't make trade-offs with engineers, someone who moves too slow, someone who "manages down" engineers instead of partnering.
     - PMM/Marketing fears: someone too technical to talk to customers, someone who overpromises on roadmap, someone who doesn't understand GTM cycles.
     - Peer PMs fear: someone who creates work for them, someone who won't respect existing ownership boundaries, a political operator.
     - Derive from: their background (what have THEY been burned by?), their role (what's their job at risk from?), their recent tenure (new to the team = hiring for immediate impact; long-tenured = hiring for culture preservation).
     - Document ONE sentence per interviewer: "Fear: {specific thing they're afraid of in this hire}."
     - Use this to shape which stories to lead with and which objections to pre-empt.
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
- **Check saved transcripts first, then Granola.** Look in `sources/<company>/` for saved transcripts; query Granola only for meetings not saved locally, and save new pulls there. If Granola is unavailable or unauthenticated, note "Granola not connected — proceeding without prior-round intel" and continue prep; never let a missing connection block the build.
- **Check what exists** — don't rebuild what's already there. Update, don't overwrite.
- **Load the company rubric** — if it doesn't exist, create it
- **Assess single vs double change** — company + domain change needs 3x the glossary and gap analysis work
- **Frame gaps as questions** — "I noticed X, is that a priority?" NOT "your product is missing X"

### Never Do:
- **Never use generic dimensions** when a company rubric exists
- **Never build prep without checking saved transcripts** (and Granola for anything not saved) for prior rounds
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
