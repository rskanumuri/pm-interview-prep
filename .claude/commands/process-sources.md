---
description: "Classify and extract insights from files in sources/ into insights, rubrics, and questions."
argument-hint: "[<company> | list | add-company <name>]"
---

# Process Source Materials

Scan source folders and extract insights into the insights files.

## Rules that must hold (kept at the top because a context compaction keeps only the start of a skill)

- **Confidentiality guard runs before any file is read for extraction** (full text in the "Confidentiality guard" section): never process a confidential workspace folder, any git-ignored file, or anything that looks like current-employer internal material. Skipped files are listed as SKIPPED (confidential), never summarized, never recorded as processed. If unsure, skip and ask.
- **Company list comes from `companies.json`,** never a hardcoded list. Ask before adding a new company.
- **Role-keyed targets:** write to `{company_key}` files when a role is clear (`interview_prep/reference/skills_core.md` §3). If the insights or rubric file already exists, keep its headings and append under "Collected Tips" or "Collected Criteria" with a dated source block; do not replace a stage-based rubric with the template below.
- **Personal folders (`sources/{active_user}/`) are not processed as insights.**
- **No session cache.** `session_data.json` (an old cache) is no longer used. Do not rebuild it; `/pm-practice` reads the live files this skill writes.
- **Manifest prevents re-processing;** files stay in the inbox.
- The templates, manifest examples and example company names further down (Stripe, Meta, DoorDash, Google) are format illustrations, not data.

## Data Files
- Sources Directory: `sources/`
- Inbox Folder: `sources/inbox/`
- Manifest: `sources/manifest.json`
- Insights Directory: `interview_prep/insights/`
- Base Rubric File: `interview_prep/rubric.md`
- **Company Rubrics Directory**: `interview_prep/rubrics/`
- Questions File: `interview_prep/questions.json`
- **Companies Registry**: `interview_prep/companies.json`

## Multi-Role File Keying

Rule: `interview_prep/reference/skills_core.md` §3 (how `{company_key}` is formed, role-keyed lookup first, where closed-company files live). If a source file clearly concerns one role, write to `{company_key}` files. If the role is unclear, use the company-only file and flag it for the user to confirm.



Parse `$ARGUMENTS`:

### No argument (default)
Process all new files in all source folders.

### `[company]` (any registered company, or general|rubric|questions)
Process only files in that company's folder (or rubric/questions folder).
Read `companies.json` to get list of valid companies.

### `list`
Show all unprocessed files without processing them.

### `add-company <name>`
Manually add a new company to the registry without processing a file.
1. Prompt user for:
   - Display name (e.g., "Google")
   - Keywords for auto-detection (e.g., "google, search, android, youtube, chrome")
2. Create entry in `companies.json`
3. Create empty `insights/{company}.md` file with template
4. Create empty `rubrics/{company}.md` file with template
5. Report success

## Dynamic Company Registry

**CRITICAL**: Always read `companies.json` to get the list of companies and their keywords.
Do NOT use hardcoded company lists.

## Inbox Auto-Classification

When processing files from `sources/inbox/`, automatically classify by content:

### Dynamic Company Detection
1. Read `companies.json` to get all companies and their keywords
2. Scan content for keywords from each company (case-insensitive)
3. **Threshold:** If 3+ keywords found for a company → classify as that company
4. If multiple companies match, split content appropriately
5. If unknown company name detected (e.g., "Google", "Airbnb" appear 3+ times):
   - Ask user before adding a new company
   - If yes → create company entry + insights file + rubric file
   - If no → route to `_general.md`
6. Default to `general` if no company match

### Type Detection
| Type | Detection |
|------|-----------|
| jd | Contains 3+ of: "About the role", "Responsibilities", "Requirements", etc. |
| questions | >5 lines ending with "?" OR patterns like "Tell me about", "How would you" |
| rubric | Contains markdown tables with score columns AND words like "criteria", "scoring" |
| insights | Default - everything else |

**JD Handling:** When a JD is detected:
1. Identify the company from content
2. Ask user: "This looks like a JD for {Company}: {Role}. Run `/eval` on it?"
3. If yes: save to `sources/{company}/jd_{role_slug}.md` and suggest running `/eval`
4. If no: route to insights as usual

### Classification Priority
1. Check for rubric patterns first (most specific)
2. Check for question density
3. Default to insights

### Mixed Content Handling

When a file contains content for multiple companies or types:

**Split by Company:**
1. Analyze each insight/paragraph for company keywords
2. Route company-specific insights → `{company}.md`
3. Route generic insights → `_general.md`

**Split by Type:**
1. Extract question-formatted content → `questions.json`
2. Extract rubric/scoring content:
   - If company detected → `rubrics/{company}.md`
   - If no company detected → `rubric.md` (base rubric)
3. Extract remaining tips → appropriate insights file

## Confidentiality guard (mandatory, runs before any file is read for extraction)

This command writes distilled content into TRACKED files (`insights/*.md`, `questions.json`, `rubric.md`). Anything it distills becomes part of the pushed repo, so it must never touch employer-confidential material.

- **Never process** anything in a confidential workspace folder, any file that `git check-ignore` reports as ignored, any file whose name or first lines mark it as an internal transcript, internal doc, price book, or colleague/personnel material, and anything dropped in `sources/inbox/` that looks like current-employer internal content (internal meeting transcripts, internal pricing, named colleagues' performance).
- For a company folder that mixes interview-era files with the user's current-employer internal files, only the interview-era files (loop transcripts, recruiter/HM debriefs, public research) may be processed.
- A skipped file is listed as `SKIPPED (confidential)` with the reason, never summarized, never quoted, and never recorded in `manifest.json` as processed.
- If unsure whether a file is confidential, skip it and ask the user. Mine every source for signal (the user's rule) applies to non-confidential sources only.

## Processing Flow

1. Read `companies.json` to get company registry
2. Read `manifest.json` to get list of already-processed files
3. Scan source folders for all files (`.md`, `.txt`, `.html`, `.png`, `.jpg`, `.jpeg`)
4. Identify new (unprocessed) files
5. **For files in `inbox/` folder, auto-classify:**
   a. Read file content
   b. Detect company using keyword matching from `companies.json`
   c. If unknown company detected, prompt user to add it (see Dynamic Company Detection)
   d. Detect type using pattern matching (see Type Detection table)
   e. For mixed content, split and route appropriately:
      - questions → questions.json (with company tag)
      - rubric + {company} → rubrics/{company}.md
      - rubric + general → rubric.md (base rubric)
      - insights + {company} → insights/{company}.md
      - insights + general → insights/_general.md
6. For each new file:
   a. Read the content
   b. Extract actionable interview insights (tips, what interviewers look for, common questions, cultural signals)
   c. Determine target file based on folder OR auto-classification
   d. Append insights to "## Collected Tips" section with source attribution
   e. If source is from rubric/ folder OR detected as rubric content:
      - Determine if company-specific (has company keywords) or general
      - Extract scoring criteria (dimensions, score descriptors, question-type mappings)
      - If company-specific → Append to "## Collected Criteria" in rubrics/{company}.md
      - If general → Append to "## Collected Criteria" section in rubric.md
   f. If source is from questions/ folder OR detected as questions:
      - Extract interview questions from free-form content
      - Categorize each question (behavioral/product_sense/product_strategy/role_career)
      - **Tag each question with detected company** (or "general" if no company match)
      - Skip duplicates and overly generic questions
      - Add new questions to questions.json with auto-assigned IDs
      - Update metadata.total and metadata.last_updated
7. Update manifest.json with newly processed files
8. Report summary: X files processed, Y insights added, Z questions added

## Extraction Guidelines

When reading source materials, extract:
- **Interview tips**: What interviewers look for, common questions, how to answer
- **Cultural signals**: Values, communication style preferences, what the company cares about
- **Product knowledge**: Products to reference, competitive landscape, recent launches
- **Frameworks**: Any structured approaches mentioned for answering questions
- **Red flags**: Things to avoid, common mistakes candidates make

**Be selective**: Only extract genuinely useful, actionable insights. Don't pad with obvious advice.

Format extracted insights as:
```markdown
### Source: {filename} ({Month Year})
- {insight 1}
- {insight 2}
- {insight 3}
```

## Rubric Extraction Guidelines

When processing files from `sources/rubric/`, extract:
- **Scoring dimensions**: New criteria categories to evaluate (e.g., "Technical Depth", "Stakeholder Awareness")
- **Score descriptors**: What constitutes a 1, 3, or 5 for each dimension
- **Question-type mappings**: Which dimensions apply to behavioral, product sense, or strategy questions
- **Red flags/green flags**: Specific behaviors that indicate low or high scores

Format extracted rubric criteria as:
```markdown
### Source: {filename} ({Month Year})

#### {Dimension Name} (1-5)
*Applies to: {Behavioral|Product Sense|Strategy|All}*

| Score | Criteria |
|-------|----------|
| 5 | {description} |
| 3 | {description} |
| 1 | {description} |
```

## Questions Extraction Guidelines

When processing files from `sources/questions/`, extract new interview questions from free-form text.

**Source file format:** Any text file - transcripts, articles, notes, question lists. Claude will:
1. Identify interview questions within the content
2. Determine the appropriate category for each question
3. **Tag with the detected company** (or "general" if generic)
4. Reformat questions to be clear and actionable

**Category determination:**
- `behavioral` - Past experiences, STAR-format questions ("Tell me about a time...")
- `product_sense` - Design questions, product improvement ("How would you design...")
- `product_strategy` - Business decisions, metrics, prioritization, go-to-market
- `role_career` - Career goals, PM qualities, company fit

**Company tagging:**
- If question mentions a specific company → tag with that company
- If question is generic (could be asked at any company) → tag as "general"
- Example: "How would you improve {Company}'s checkout flow?" → `company: "{company}"`
- Example: "Tell me about a time you failed" → `company: "general"`

**Processing rules:**
1. Read questions.json to get current max ID and existing questions
2. Extract questions from source content
3. For each extracted question:
   - Check for duplicates (skip if too similar to existing)
   - Determine category
   - Determine company tag
   - Assign next available ID (max_id + 1)
   - Add to questions array
4. Update metadata.total count
5. Update metadata.last_updated to current date
6. Write updated questions.json

**Quality filters:**
- Skip questions that are too similar to existing ones
- Skip overly generic questions (e.g., "Tell me about yourself")
- Ensure questions are complete and actionable
- Report extracted count and any skipped questions in output

## Handling Different File Types

- **Text/Markdown (.md, .txt)**: Read directly, extract insights
- **HTML (.html)**: Read and parse the text content, extract insights
- **Images (.png, .jpg, .jpeg)**: Describe what you see, extract any visible tips/frameworks/diagrams
- **URLs in .txt files**: If a file contains URLs, fetch the URL content and extract insights

## Folder to Target File Mapping

| Source Folder | Target File |
|---------------|-------------|
| `sources/inbox/` | **Auto-detected** based on content |
| `sources/general/` | `insights/_general.md` |
| `sources/{company}/` | `insights/{company}.md` (for any registered company) |
| `sources/rubric/` | `rubric.md` |
| `sources/questions/` | `questions.json` |
| `sources/{active_user}/` | **Personal docs** — resume, STAR stories (loaded by `/pm-practice`) |

**Note:** Personal folders contain resumes and STAR stories. These are NOT processed as insights — they're loaded directly by `/pm-practice` for the active user.

## Key Rules

- Always read `companies.json` for dynamic company detection — never hardcode
- Ask before adding new companies
- Split mixed content appropriately
- Update manifest to prevent re-processing
