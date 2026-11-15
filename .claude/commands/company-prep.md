---
description: "Scaffold all prep artifacts for a new company or role, including cheat sheet, insights, rubric, why script, and registry entry."
argument-hint: "<company> [role] | <company> update | <company> status | list"
---

# Company Prep Scaffolder

Full-service company prep automation. One command generates all interview artifacts for a new company.

## Active User

Rule: `interview_prep/reference/skills_core.md` §4. Read `progress.json` `active_user`; personal material comes only from `sources/{active_user}/` and `interview_prep/story_bank.json`.

## Data Files

- Companies Registry: `interview_prep/companies.json`
- Progress: `interview_prep/progress.json`
- Cheat Sheet Template: reference an existing cheat sheet in `interview_prep/scripts/` for structure (use the most recent one as the template)
- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Insights Directory: `interview_prep/insights/`
- Rubrics Directory: `interview_prep/rubrics/`
- CLAUDE.md: `CLAUDE.md` (project root)
- Personal Docs: `sources/{active_user}/` (resume, performance kit, stories)
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, story inventory)
- Evaluation (if exists): `interview_prep/evaluations/{company}_*_eval.json`: if an /eval was run, use its archetype detection, keyword analysis, and JD requirement mapping to seed the cheat sheet's "Fit → JD Mapping" table and inform rubric dimensions

## Multi-Role File Keying

Rule: `interview_prep/reference/skills_core.md` §3 (how `{company_key}` is formed, role-keyed lookup first, where closed-company files live). Every `{company}` in a file path below means `{company_key}`. The human-readable company name still appears in file content; only the filename and registry key change.



Parse `$ARGUMENTS` to determine the command:

### `<company> [role]` — Full Scaffold

Generate all interview prep artifacts for a new company. If the company already exists in the registry, warn and ask if they want to update instead.

**Steps:**

1. **Read existing state:**
   - Read `interview_prep/companies.json` for registry
   - Read `interview_prep/progress.json` for current state
   - Read the user's source docs for story/number inventory:
     - `sources/{active_user}/` (all personal materials — resume, performance kit, stories, proof points)
   - Read story bank:
     - `interview_prep/story_bank.json` (canonical stories, numbers)
   - Read master story registry:
     - `interview_prep/scripts/master_story_repository.md` (canonical story narratives)

2. **Research the company and role:**
   - Use WebSearch to gather: company mission, values, culture, recent news, funding, product launches, interview tips, role requirements, key products, competitors, market position, revenue/growth
   - If role is specified, research that specific role/team

3. **Create cheat sheet** at `interview_prep/scripts/{company}_cheat_sheet.md` following the structure of existing cheat sheets:
   - Header with date/type/role
   - "If they ask X, start with Y" card (TMAY, system walkthrough, AI-fluency question)
   - TMAY (customized from performance kit with company hook)
   - System walkthrough, 4 minutes, result first (required for AI, platform, infrastructure and other technical roles; structure in `/interview-prep` Stage 1, deliverable 7)
   - Why {Company}? Why Now? (Three Beats: What I've done, What I see here, Why now)
   - Recruiter Q&A (4-5 likely questions with scripted answers bridging the user's experience)
   - Story Map table (5 rows: theme, primary story, key numbers, bridge)
   - Quick Reference Card (5 rows: topic → lead with)
   - Questions to Ask Them (4 questions)
   - Role Quick Facts (company, product, mission, role focus, scope, culture)

4. **Create insights file** at `interview_prep/insights/{company}.md`:
   - Mission, Core Values, What Interviewers Look For, Products to Reference, Competitive Landscape, Interview Tips, Collected Tips section

5. **Create rubric** at `interview_prep/rubrics/{company}.md`:
   - 3-4 company-specific scoring dimensions (1-5 tables, green/red flags)
   - Match dimensions to company values (dev tools → Developer Empathy; enterprise → Enterprise Acumen; AI/ML → Technical Rigor; marketplace → Marketplace Thinking)
   - If the rubric has a recruiter-screen stage, its story row is "Main story asked for" (a TMAY or a system walkthrough, whichever the interviewer asks for), not "TMAY". Do not add a rubric row whose failure condition is the same as one of the five pre-interview rules; those are already penalized once (`debrief_core.md` §1).

6. **Seed Company-Specific Angles in master_story_repository.md** — For the top 5 stories mapped in the cheat sheet's Story Map:
   - Open `interview_prep/scripts/master_story_repository.md`
   - Find each story's `## Company-Specific Angles` table
   - Add a new row: `| {Company} | {frame from story map theme} | "{bridge line from cheat sheet}" | No | — |`
   - This ensures angles are immediately available to `/story-map`, `/steelman`, and other commands that read the master repo

7. **Add to companies registry** (`interview_prep/companies.json`):
   - Entry with name, keywords (8-12 terms), created date. Do NOT change `default` field.

8. **Append Why script** to `interview_prep/scripts/why_company_role_scripts.md`:
   - Follow exact format: Why {Company}? (30 sec), Why This Role? (15 sec), Three Beats, Rules
   - Number as next entry

9. **Update CLAUDE.md** — add or update this company's row in the Active Pipeline section (company, role, stage, files). Keep company detail (team, bridge strategy, honest gaps) in the company's own files, not in CLAUDE.md.

10. **Update progress.json** — add company_readiness entry:
   ```json
   "{company}": {
     "percent": 10,
     "stage": "prep",
     "status": "Initial scaffold created. Cheat sheet, insights, rubric ready.",
     "remaining": ["verbal reps", "mock practice", "story mapping refinement"]
   }
   ```
   Also write `interview_dates.{company_key}` when an interview is already scheduled (format and rules: `interview_prep/reference/skills_core.md` §1). If mail or calendar tools are connected, take the date from the newest invite; otherwise ask once. `/pipeline`, `/battle-plan` and `/prep-check` cannot see an interview that is not in `interview_dates`. Follow the JSON write rules in `skills_core.md` §2.

11. **No cache step.** `session_data.json` (an old cache) is no longer used. `/pm-practice` reads the live rubric, insights and registry files, so the new company is available as soon as steps 3 to 7 are written.

12. **Report summary** showing all created files and next steps.

### `<company> update` — Update Existing Prep

Refresh prep with new intel (e.g., after recruiter call).

1. Read existing artifacts (cheat sheet, insights, rubric, CLAUDE.md pipeline row)
2. Ask user what new intel they have (recruiter notes, role changes, interview details, company news)
3. Update all relevant files with new information
4. Report what was updated

### `<company> status` — Prep Completeness Check

Show what prep artifacts exist vs what's missing. Check: cheat sheet, insights, rubric, registry entry, why script, CLAUDE.md pipeline row, progress entry, debrief files. For existing files check content completeness (TMAY, Story Map, Q&A, dimensions, etc). Display matrix with checkmarks and recommendations.

### `list` — All Companies Prep Matrix

Show all registered companies with prep completeness columns (Cheat, Insight, Rubric, Why, CLAUDE, Ready%, Status). Read companies.json + progress.json + check artifact existence.

## Key Rules

- **Always use WebSearch** for company research — don't rely on stale knowledge
- **Always read the user's source docs** to customize TMAY and story mapping
- **Never overwrite existing files** without asking — use `update` subcommand
- **There is no session cache.** `session_data.json` (an old cache) is no longer used; do not recreate it
- **Follow existing templates exactly** — consistency across companies matters
- **Career thesis** (from CLAUDE.md) should thread through all company-specific content
- **Pre-interview rules** (`interview_prep/reference/skills_core.md` §6) apply to all generated scripts
- **Canonical numbers**: read them from `story_bank.json` `canonical_numbers` and word them per `canonical_provenance`. No copy is kept in this file (copies drift). Run the canon check on the finished cheat sheet before reporting.
- **Company key in filenames/registry**: lowercase, underscores for spaces (e.g., `palo_alto_networks`)
