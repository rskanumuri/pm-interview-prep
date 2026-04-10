# Story Bank — Central Story Management

Manages the user's canonical story bank. The story bank is the single source of truth for story metadata, angles, performance data, and company mappings.

## Data Files

- **Story Bank JSON**: `interview_prep/story_bank.json` (canonical index — all metadata, angles, performance)
- **Story Bank MD**: `interview_prep/story_bank.md` (auto-generated scannable index — NEVER hand-edit)
- **Narrative Library**: `interview_prep/scripts/master_story_repository.md` (full prose for each story)
- **Scripted Versions**: Various files referenced in each story's `scripted_versions` field
- **Canonical Numbers**: Embedded in `story_bank.json` under `canonical_numbers` AND in CLAUDE.md
- **Purged Stories**: Listed in `story_bank.json` under `purged_stories`

## Commands

Parse `$ARGUMENTS` to determine the command:

### (no args) — Show Quick Index

Read `interview_prep/story_bank.json`. Display the Quick Index table:

| # | Story | Key Number | Status | Angles | Times Told |

Sort by: stories with `performance.status = "needs_work"` first, then by `last_reviewed` (oldest first).

### `add <name>` — Add New Story

Interactive flow:
1. Ask for: company_origin, year, one_liner, headline_number, key_numbers
2. Ask for themes (from fixed taxonomy below)
3. Ask for question_types mapping
4. Ask which companies this story bridges to
5. Create the JSON entry in `story_bank.json`
6. Offer to create the full narrative in `master_story_repository.md`
7. Regenerate `story_bank.md`

### `import` — Bulk Import Existing Stories (and Questions)

Onboards stories and questions the user already has prepared — from Google Docs, notes, previous prep, or any format.

#### Input Detection

Accept `$ARGUMENTS` after `import`. If args contain a file path, read that file. Otherwise, prompt:

```
STORY BANK IMPORT

Paste or point me to your existing prep material. I can handle:

  1. PASTE TEXT    — dump your Google Doc, notes, or prep sheet right here
  2. FILE PATH    — path to a .md, .txt, or .json file in the repo
  3. JSON ARRAY   — raw JSON array of story objects

I'll parse stories from any format: STAR bullets, narrative paragraphs,
tables, numbered lists, or structured JSON.

If your material also contains interview questions, I'll capture those too.
```

#### Format Detection & Parsing

Read the input and classify format:

| Format | Detection | Parsing Strategy |
|--------|-----------|-----------------|
| **Structured JSON** | Valid JSON array where objects have 2+ of: `title`, `situation`, `task`, `action`, `result`, `company`, `year` | Map fields directly to story schema. Fill missing fields with `null`. |
| **STAR-formatted** | Contains patterns like "Situation:", "Task:", "Action:", "Result:" (case-insensitive, with or without bold/headers) | Split on STAR headers. Each STAR block = one story. |
| **Numbered/bulleted list** | Lines starting with `1.`, `2.`, `-`, `*` where each item describes an accomplishment with context | Each item = one story. Parse for company, year, metric, and action. |
| **Narrative paragraphs** | Multi-paragraph text with story-like content (accomplishments, metrics, outcomes) | Use paragraph breaks + topic shifts to segment stories. Each segment = one story. |
| **Table format** | Markdown or tab-separated table with column headers matching story fields | Map columns to schema fields. Each row = one story. |
| **Mixed with questions** | Lines ending with `?` or starting with "Tell me about", "How would you", "Describe a time", "Why do you" | Separate questions from stories. Process stories below, questions into `questions.json`. |

#### Story Extraction

For each detected story, extract into this schema:

```json
{
  "id": "{snake_case_from_title}",
  "title": "{Descriptive title — infer if not explicit}",
  "product": "{Product/Project — extract or null}",
  "company": "{Company — extract or null}",
  "year": "{Year — extract or null}",
  "themes": [],
  "one_liner": "{One sentence with key metric — generate from content}",
  "situation": "{Extract or null}",
  "task": "{Extract or null}",
  "action": "{Extract or null}",
  "result": "{Extract or null}",
  "key_numbers": {},
  "best_for": [],
  "company_angles": {},
  "angles": [],
  "performance": { "status": "imported", "times_told": 0 }
}
```

Extraction rules:
- **id**: snake_case from title, max 40 chars, unique
- **title**: If not explicit, generate from the core accomplishment (e.g., "Platform Migration at Acme")
- **themes**: Auto-tag from the theme taxonomy based on content. Assign 2-4 themes per story.
- **one_liner**: Always generate — one sentence capturing the story + key metric
- **key_numbers**: Extract ALL quantified metrics (dollar amounts, percentages, user counts, time savings)
- **best_for**: Infer question types this story fits (e.g., "leadership", "technical challenge", "conflict", "failure", "impact", "cross-functional", "strategy")
- **performance.status**: Set to `"imported"` (distinct from `"ready"` which means reviewed/polished)

#### Deduplication

Before writing:
1. Read existing `story_bank.json`
2. For each extracted story, check for duplicates:
   - Same `company` + similar `title` (fuzzy match)
   - Same `company` + same `year` + overlapping `key_numbers`
   - Same `one_liner` similarity > 80%
3. If duplicate found, show both and ask: "This looks similar to existing story '{title}'. Skip, merge, or add as separate?"

#### Question Extraction

If questions are detected in the input:
1. Extract each question
2. Classify by type: `behavioral`, `product_sense`, `technical`, `estimation`, `strategy`, `execution`, `leadership`, `analytical`
3. Tag with source (e.g., "imported from user notes")
4. Write to `interview_prep/questions.json`

#### Output Flow

1. Show the user what was parsed BEFORE writing:

```
IMPORT PREVIEW

  STORIES FOUND: {N}
  ──────────────
  1. {title} ({company}, {year}) — {one_liner}
     Themes: {themes}  |  Best for: {best_for}
     STAR: {✓ complete | ⚠ partial — missing: task, result}

  2. {title} ({company}, {year}) — {one_liner}
     ...

  {if questions found:}
  QUESTIONS FOUND: {M}
  ────────────────
  1. [{type}] {question text}
  2. [{type}] {question text}
  ...

  {if duplicates found:}
  ⚠ POSSIBLE DUPLICATES: {D} — I'll ask about each one.

Looks right? (yes / edit numbers / remove #N / cancel)
```

2. Handle user response:
   - **"yes"** → write all
   - **"edit"** → interactive corrections for specific stories
   - **"remove #N"** → drop that story from import
   - **"cancel"** → abort

3. After confirmation:
   - Write stories to `story_bank.json` (append to existing `stories[]`, update `metadata.total_stories` and `metadata.last_updated`)
   - Write questions to `interview_prep/questions.json` (if any)
   - Regenerate `interview_prep/story_bank.md`
   - Update `canonical_numbers` in `story_bank.json` with any new key numbers

4. Final report:

```
IMPORT COMPLETE

  ✓ {N} stories added to story bank ({total} total)
  {✓ {M} questions added to questions bank | (no questions detected)}
  {⚠ {D} stories skipped as duplicates}

  Stories marked as "imported" — run /story-bank to review.
  To polish STAR details: /story-bank add {story_id} (re-opens for editing)

  Next steps:
  - /story-bank              Review your full story bank
  - /story-bank sync         Sync with other prep files
  - /steelman {story_id}     Pressure-test a specific story
```

5. Offer: "Save everything to git? (`/save-push`)"

#### `import --questions-only`

If the user only has questions (no stories), skip story parsing entirely. Accept a list of questions and write directly to `questions.json`.

### `sync` — Sync Story Bank with Source Files

This is the KEY freshness mechanism. Run this proactively.

1. Read `story_bank.json`
2. Read `master_story_repository.md` — check for:
   - New stories not in JSON
   - Number changes that don't match JSON `key_numbers`
   - New Company-Specific Angles tables not reflected in JSON `company_angles`
3. Read recent debrief files in `interview_prep/answers/*_debrief_*.md` — check for:
   - Stories told that aren't reflected in `performance.interviews[]`
   - Scores not captured
4. Read company cheat sheets — check for story maps not reflected in `company_angles`
5. Report all diffs found
6. Offer to update JSON with each change
7. After updates, regenerate `story_bank.md`

### `refresh` — Regenerate story_bank.md

Read `story_bank.json` and regenerate `interview_prep/story_bank.md` with:
1. Quick Index table
2. By Question Type section
3. By Company round allocation
4. Performance Dashboard
5. Health Warnings

### `stale` — Show Stale Stories

Read `story_bank.json`. Show stories where:
- `last_reviewed` is more than 14 days ago
- `performance.status` is "needs_work"
- `performance.times_told` is 0 and story has `company_angles` for active pipeline companies

### `allocate <company>` — Round Allocation

Read `story_bank.json`. For the given company:
1. Show all stories with `company_angles[company]` entries
2. Group by `planned_round`
3. Check for NO-REPEAT violations (same story in multiple rounds)
4. Show gaps (rounds with no stories allocated)
5. Allow editing: move stories between rounds, add new allocations

### `performance` — Performance Dashboard

Read `story_bank.json`. Show:
1. **Tested stories**: sorted by score (lowest first = needs most work)
2. **Most-used stories**: sorted by `times_told` (flag overuse > 3)
3. **Never-told stories**: with company angles but never used live
4. **Angles by story**: stories with 2+ proven angles
5. **Score trend**: any stories getting better or worse over time

### `angles <story>` — Show All Angles for a Story

Match `<story>` against story `id`, `name`, or `short_name` (case-insensitive).
Show:
1. All entries in `angles[]` array with context, times_used, landed status
2. All `company_angles` entries with frame, bridge, tested status
3. Suggest new angles based on themes and question_types

## Angle Extraction — How New Angles Get Captured

When the user tells a story during `/drill-rapid`, `/pm-practice`, `/debrief`, or `/debrief-live`:

1. Identify which story was told (match against story names in bank)
2. Compare the user's framing against stored `angles[]` entries
3. If the framing is meaningfully different (new bridge, different emphasis, different lesson):
   - Prompt: "New angle detected for [story]: '[angle description]'. Add to story bank?"
   - If yes, append to `angles[]` in `story_bank.json`:
     ```json
     {
       "name": "descriptive name",
       "frame": "how it was framed",
       "first_used": "YYYY-MM-DD",
       "context": "where it was used (company, round, or practice)",
       "times_used": 1,
       "landed": null
     }
     ```
4. After any debrief, also update `company_angles[company].tested` and `.score`

## Theme Taxonomy (fixed list)

```
deliver_results, customer_obsession, earn_trust, ownership,
think_big, dive_deep, bias_for_action, are_right_a_lot,
learn_and_be_curious, tight_deadline, overcame_obstacles,
exceeded_expectations, said_no, pricing, gtm_marketing,
cross_functional, technical_depth, product_vision,
program_management, resilience, accountability_failure,
team_morale, influence_without_authority, initiative, analytical
```

## Standing Rules

1. **Before ending any conversation** where story-related files were modified, offer: "Run `/story-bank sync`?"
2. **After any `/debrief`, `/debrief-live`, `/drill-rapid`, or `/pm-practice`**, offer: "Update story bank with this session's data?"
3. **Canonical numbers in JSON must match CLAUDE.md** — if they diverge, flag immediately
4. **Never include purged stories** in any output
5. **story_bank.md is ALWAYS auto-generated** — never hand-edit it
