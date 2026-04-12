# Process Source Materials

Scan source folders and extract insights into the insights files.

## Data Files
- Sources Directory: `sources/`
- Inbox Folder: `sources/inbox/`
- Manifest: `sources/manifest.json`
- Insights Directory: `interview_prep/insights/`
- Base Rubric File: `interview_prep/rubric.md`
- **Company Rubrics Directory**: `interview_prep/rubrics/`
- Questions File: `interview_prep/questions.json`
- Session Data (consolidated cache): `interview_prep/session_data.json`
- **Companies Registry**: `interview_prep/companies.json`

## Multi-Role File Keying

When reading/writing company-keyed files (insights, rubrics), follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". If a source file's content references a specific role at a company, classify and write to `{company}_{role_slug}_*` artifacts. If role is unclear, fall back to `{company}_*` and flag for the user to confirm.

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

## Processing Flow

1. Read `companies.json` to get company registry
2. Read `manifest.json` to get list of already-processed files
3. Scan source folders for all files (`.md`, `.txt`, `.html`, `.png`, `.jpg`, `.jpeg`)
4. Identify new (unprocessed) files
5. For each new file: read, classify, extract insights, route to target file
6. Update manifest.json with newly processed files
7. Regenerate session_data.json
8. Report summary: X files processed, Y insights added, Z questions added

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
- Regenerate session_data.json after processing to keep cache in sync
