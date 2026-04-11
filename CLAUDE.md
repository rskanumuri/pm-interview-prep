<!-- INIT_STATUS: unconfigured -->
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

PM interview preparation workspace. **Run `/setup` to get started — it takes 5 minutes.**

## Quick Start

1. Type `/setup` in Claude Code
2. Follow the wizard (paste your resume, answer a few questions)
3. Start prepping with 24 slash commands

If you prefer manual setup, see `SETUP.md`.

---

## Active Pipeline

*Not configured. Run `/setup` to populate.*

## Career Profile

*Not configured. Run `/setup` to populate.*

## Job Search Config

*Not configured. Run `/setup` to populate.*

---

## Standing Workflow Rules

These rules govern how the system behaves. They apply regardless of your profile.

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
- `story_bank.md` is always auto-generated from JSON — never hand-edit it

### Timed Agents

- When research is requested without using `/timed-research`, ask: "Want it timed? (default: 10 min)"
- All background research agents MUST use the timed-research pattern
- Never launch untimed background agents for research tasks

### Cost Optimization — Agent Model Routing

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

### Working Style Preferences

- Be direct. Don't over-explain.
- When creating content, write it fully. Don't give summaries and ask "should I write it?"
- Never invent story details. If you don't have the data, say so.
- When dates/numbers are corrected, update ALL files, not just the one being discussed.
- When told "yes, do it" — execute immediately, don't ask clarifying questions.

### Career Learning Hooks

- After any `/debrief` or `/debrief-live`, automatically compare this round's patterns against `interview_prep/interview_lessons.md` and PROPOSE specific updates (extract from debrief data, show the proposed change — don't ask the user to generate).
- When archiving a rejected company, read all debriefs for that company, cross-reference with `interview_prep/career_takeaways.md`, and PROPOSE a specific career takeaway. User reviews and approves.
- When archiving a rejected company, if `{company}_phantom.md` exists, update it with post-mortem: "The candidate who got this job probably had X." Final version becomes a learning artifact.
- Living docs: `interview_prep/career_takeaways.md` (career wisdom) + `interview_prep/interview_lessons.md` (learned vs still learning)

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

### Top-of-Funnel Skills

- "evaluate role" / "check this JD" → `/eval`
- "find roles" / "scan jobs" → `/scan`
- "tailor resume" / "make CV" → `/cv-gen`
- "full pipeline" / "process this JD" → `/auto-pipe`
- "fill application" → `/apply`

---

## Inbox

- `sources/inbox/` — Drop anything here, auto-classified by `/process-sources`
