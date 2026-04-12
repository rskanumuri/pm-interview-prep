# Company Prep Scaffolder

Full-service company prep automation. One command generates all interview artifacts for a new company.

## Active User

Check `progress.json` for the `active_user` field. Load personal info from `sources/{active_user}/`.

## Data Files

- Companies Registry: `interview_prep/companies.json`
- Session Data: `interview_prep/session_data.json`
- Progress: `interview_prep/progress.json`
- Cheat Sheet Template: reference an existing cheat sheet in `interview_prep/scripts/` for structure (use the most recent one as the template)
- Why Scripts: `interview_prep/scripts/why_company_role_scripts.md`
- Insights Directory: `interview_prep/insights/`
- Rubrics Directory: `interview_prep/rubrics/`
- CLAUDE.md: `CLAUDE.md` (project root)
- Personal Docs: `sources/{active_user}/` (resume, performance kit, stories)
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, story inventory)
- Evaluation (if exists): `interview_prep/evaluations/{company}_*_eval.json` — if an /eval was run, use its archetype detection, keyword analysis, and JD requirement mapping to seed the cheat sheet's "Fit → JD Mapping" table and inform rubric dimensions

## Multi-Role File Keying

When a company has multiple roles being tracked, files are keyed by `{company}_{role_slug}` instead of `{company}` alone, so two roles at the same company can coexist without overwriting each other.

**`{company_key}` resolution:**
- `role_slug` = role string lowercased, non-alphanumeric → underscores, collapsed (e.g., "Senior PM, Data Governance" → `senior_pm_data_governance`)
- If `<role>` argument is provided: `{company_key}` = `{company}_{role_slug}`
- If `<role>` argument is NOT provided: `{company_key}` = `{company}` (legacy single-role pattern, preserves back-compat)

**All `{company}` references in file paths below should be interpreted as `{company_key}` per this rule.** The human-readable company name still appears in file content; only the filename/registry key changes.

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
   - TMAY (customized from performance kit with company hook)
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

9. **Update CLAUDE.md** — append `### {Company}-Specific Context` section under Active Sprint, following existing company section patterns (role, team, key details, bridge strategy, honest gaps)

10. **Update progress.json** — add company_readiness entry:
   ```json
   "{company}": {
     "percent": 10,
     "status": "Initial scaffold created. Cheat sheet, insights, rubric ready.",
     "remaining": ["verbal reps", "mock practice", "story mapping refinement"]
   }
   ```

11. **Regenerate session_data.json** — read all source files and merge into standard structure so `/pm-practice` picks up the new company immediately.

12. **Report summary** showing all created files and next steps.

### `<company> update` — Update Existing Prep

Refresh prep with new intel (e.g., after recruiter call).

1. Read existing artifacts (cheat sheet, insights, rubric, CLAUDE.md section)
2. Ask user what new intel they have (recruiter notes, role changes, interview details, company news)
3. Update all relevant files with new information
4. Regenerate session_data.json
5. Report what was updated

### `<company> status` — Prep Completeness Check

Show what prep artifacts exist vs what's missing. Check: cheat sheet, insights, rubric, registry entry, why script, CLAUDE.md section, progress entry, debrief files. For existing files check content completeness (TMAY, Story Map, Q&A, dimensions, etc). Display matrix with checkmarks and recommendations.

### `list` — All Companies Prep Matrix

Show all registered companies with prep completeness columns (Cheat, Insight, Rubric, Why, CLAUDE, Ready%, Status). Read companies.json + progress.json + check artifact existence.

## Key Rules

- **Always use WebSearch** for company research — don't rely on stale knowledge
- **Always read the user's source docs** to customize TMAY and story mapping
- **Never overwrite existing files** without asking — use `update` subcommand
- **Always regenerate session_data.json** after any file changes
- **Follow existing templates exactly** — consistency across companies matters
- **Career thesis** (from CLAUDE.md) should thread through all company-specific content
- **Pre-interview rules** (from CLAUDE.md) apply to all generated scripts
- **Canonical numbers** from story_bank.json must be used exactly — never round, never approximate
- **Company key in filenames/registry**: lowercase, underscores for spaces (e.g., `palo_alto_networks`)
