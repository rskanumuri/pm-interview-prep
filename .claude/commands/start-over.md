# Start Over — Full Workspace Wipe

Returns the workspace to a clean, never-configured state so you can start from scratch (new job search, new career chapter, or handing the repo to someone else). Deletes ALL personal data. System files (skills, hooks, tools, templates, master rubric) are never touched.

This is the heavy option. For a lighter reset that keeps your resume and company research, use `/setup reset`.

> Named `/start-over`, not `/reset`, because `/reset` is a built-in Claude Code alias of `/clear` and would never reach this file.

## Data Files

### Read
- Everything under the Inventory below (to list and back it up)
- `.claude/commands/*.md` (count only, for the Quick Start line)

### Write
- Backup zip OUTSIDE the repo
- Seed JSON files (see Seeds)
- `CLAUDE.md` (back to the unconfigured state)

## Commands

Parse `$ARGUMENTS`:

- (no args): full flow (inventory, typed confirmation, backup, wipe, verify)
- `--dry-run`: inventory only. Nothing is backed up, deleted, or written.

## Flow

### Step 0 — Safety checks

1. Confirm the working directory is the PM interview prep repo root: `.claude/commands/start-over.md` AND `interview_prep/progress.json` must both exist. If either is missing, stop: "This doesn't look like the PM interview prep repo root. Nothing changed."
2. Run `date +%Y%m%d-%H%M%S` for the backup timestamp. Never guess the time.
3. Note: `sources/*/` is gitignored, so git cannot restore it. The backup zip in Step 3 is the only recovery path for those files.

### Step 1 — Inventory (always runs, including `--dry-run`)

Build the full list of what will be deleted or reset. Show it grouped, with file counts and total size, then list every path.

**DELETE (personal data):**
- `sources/<name>/` for every subfolder EXCEPT `sources/your_name/`. In `sources/your_name/`, delete everything except `README.md`.
- `sources/inbox/*` except `.gitkeep`
- `interview_prep/answers/*`, `evaluations/*`, `insights/*`, `research/*`, `rubrics/*`, `scripts/*` (keep each folder's `.gitkeep`)
- These loose files in `interview_prep/` if present: `story_bank.md`, `question_bank.md`, `question_bank_clean.md`, `interview_lessons.md`, `career_takeaways.md`
- `output/*` except `output/cv/.gitkeep` (recreate the `.gitkeep` files if missing)

**RESET to seed (see Seeds):**
- `interview_prep/applications.json`, `companies.json`, `progress.json`, `questions.json`, `session_data.json`, `story_bank.json`
- `config/portals.json`, `config/scan_history.json`
- `sources/manifest.json`
- `CLAUDE.md` (see Step 5)

**NEVER TOUCH:**
- `.claude/` (skills, hooks, settings, `settings.local.json`), `tools/`, `README.md`, `SETUP.md`, `LICENSE`, `.gitignore`, `.git/`
- `interview_prep/rubric.md` (master rubric, system file)

**UNRECOGNIZED:** any other file or folder under `sources/`, `interview_prep/`, `config/`, or `output/` that is not matched above (for example a `reference/` folder or a hand-made notes file). Do NOT delete these. List them in a separate "Kept, not recognized" group so the user can decide.

If the inventory is already at seed state (nothing to delete, JSON files match seeds, CLAUDE.md has the unconfigured sentinel), say "Workspace is already clean. Run `/setup` to get started." and stop.

If `--dry-run`: end here with "Dry run only. Nothing was changed."

### Step 2 — Typed confirmation

Show the item counts and the backup path that will be created, then say:

```
This permanently deletes the files listed above. A backup zip will be saved at:
  {backup_path}

Type RESET to continue. Anything else cancels.
```

Only the exact text `RESET` proceeds. "yes", "y", "ok", or "do it" cancel. Never treat earlier approval of a different action as confirmation.

### Step 3 — Backup (mandatory, no skip)

1. Backup path: `{parent_of_repo}/{repo_folder_name}-backup-{timestamp}.zip`. Must be outside the repo so a wipe or `git clean` cannot touch it.
2. Zip every path listed under DELETE and RESET, plus the UNRECOGNIZED group, preserving relative paths. Try in order: `zip -r`, `tar -a -cf <file>.zip`, PowerShell `Compress-Archive`. Use whichever exists.
3. Verify before continuing: the zip exists, is larger than 0 bytes, and lists at least one entry per top-level group that had files.
4. If the backup fails or cannot be verified: STOP. Delete nothing. Report the error.

### Step 4 — Wipe

Delete the DELETE group, then write the seed JSON files. Use plain per-path deletes. Do not use broad globs on the repo root, and do not run any `git clean`, `git reset`, or `git checkout` for this. Skip every path in NEVER TOUCH and UNRECOGNIZED. Recreate any missing `.gitkeep` files in `interview_prep/{answers,evaluations,insights,research,rubrics,scripts}`, `output/cv`, and `sources/inbox`.

### Step 5 — CLAUDE.md back to unconfigured

Edit the existing `CLAUDE.md` in place (this keeps the system rules in sync with whatever version is installed):

1. Replace line 1 with `<!-- INIT_STATUS: unconfigured -->`.
2. Replace the body of `## Purpose` with: `PM interview preparation workspace. **Run /setup to get started. Takes 5 minutes.**` (backticks around `/setup`).
3. Ensure these two sections follow Purpose, adding them if missing:
   - `## Operating Principle` with: **Interviews are research, not performance.** The questions you're asked compound across rounds. The answers you gave don't. This system is built to capture questions (`question_bank.md`), patterns (`interview_lessons.md`), and wisdom (`career_takeaways.md`) so each interview makes the next one easier.
   - `## Quick Start` with: 1. Type `/setup` in Claude Code. 2. Follow the wizard (paste your resume, answer a few questions). 3. Start prepping with {N} slash commands. Then: "If you prefer manual setup, see `SETUP.md`." `{N}` = number of `.claude/commands/*.md` files, counted now, never hardcoded.
4. Replace everything from `## Active Pipeline` up to the `---` that precedes `## Standing Workflow Rules` with three placeholder sections: `## Active Pipeline`, `## Career Profile`, `## Job Search Config`, each containing only `*Not configured. Run /setup to populate.*` (backticks around `/setup`).
5. Delete the `### Story Integrity — Canonical Numbers` and `### Purged Stories — NEVER USE` sections (heading through the line before the next `###`). These hold the user's own numbers.
6. Leave all other system sections (Standing Workflow Rules and below) exactly as they are.

If the expected anchors are missing (no `## Standing Workflow Rules` heading), do NOT guess. Leave `CLAUDE.md` untouched, say so, and tell the user to restore it from the backup or from the `CLAUDE.md` template in `.claude/commands/setup.md` (Phase 6).

### Step 6 — Verify and report

Check: `progress.json` has `"active_user": "your_name"`, `CLAUDE.md` line 1 is the unconfigured sentinel, `sources/` holds only `inbox/`, `your_name/README.md`, and `manifest.json` (plus anything in the Kept group), and the system files in NEVER TOUCH still exist.

```
START OVER COMPLETE

  Deleted:      {N} files in {M} folders
  Reset:        {K} files to seed state
  Kept (unrecognized): {list or "none"}
  Backup:       {backup_path} ({size})

Next:
  1. /setup            Rebuild your profile from your resume
  2. /save-push        Commit the clean state (optional; the backup is your undo)

Delete the backup zip once you're sure you don't need it. It contains your resume and interview notes.
```

Do NOT commit or push automatically.

## Seeds

Write these files exactly. Keep in sync with the files shipped in the repo; when a seed file's schema changes, update the matching block here.

`interview_prep/applications.json`
```json
{
  "metadata": {
    "version": "1.0",
    "last_updated": "2026-01-01",
    "total": 0,
    "statuses": ["discovered", "evaluating", "ready_to_apply", "applied", "interviewing", "offered", "rejected", "withdrawn", "closed"]
  },
  "applications": {}
}
```

`interview_prep/companies.json`
```json
{
  "default": "example",
  "companies": {
    "example": {
      "name": "Example Corp",
      "keywords": ["example", "demo", "sample company"],
      "created": "2026-01-01"
    }
  }
}
```

`interview_prep/progress.json`
```json
{
  "active_user": "your_name",
  "start_date": null,
  "interview_dates": {},
  "target_company": null,
  "follow_up_mode": "deep",
  "pre_interview_warmup": {},
  "company_readiness": {}
}
```

`interview_prep/questions.json`
```json
{
  "metadata": {
    "version": "1.0",
    "last_updated": null,
    "total_questions": 0,
    "sources": []
  },
  "questions": []
}
```

`interview_prep/session_data.json`
```json
{
  "metadata": {
    "version": "1.0",
    "last_consolidated": "2026-01-01",
    "description": "Consolidated master file loaded once per session. Contains all questions, stories, rubric, and company data."
  },
  "companies": {},
  "questions": {
    "behavioral": [],
    "product_sense": [],
    "execution": [],
    "analytical": [],
    "technical": [],
    "general": [
      {"id": "tmay", "question": "Tell me about yourself", "category": "general", "frequency": "every_interview"},
      {"id": "why_company", "question": "Why this company?", "category": "general", "frequency": "every_interview"},
      {"id": "why_pm", "question": "Why product management?", "category": "general", "frequency": "common"}
    ]
  },
  "star_stories": [],
  "rubric": {
    "universal": {
      "delivery": {"weight": 1, "scale": 5, "description": "Clarity, pacing, confidence, conciseness"},
      "company_fit": {"weight": 1, "scale": 5, "description": "How well the answer maps to this company's values and needs"}
    },
    "format_specific": {
      "behavioral": {
        "structure": {"weight": 2, "scale": 5, "description": "Clear STAR format with measurable results"},
        "specificity": {"weight": 2, "scale": 5, "description": "Concrete details, not vague generalizations"},
        "ownership": {"weight": 2, "scale": 5, "description": "Clear individual contribution, not team attribution"}
      },
      "product_sense": {
        "user_empathy": {"weight": 2, "scale": 5, "description": "Deep understanding of user needs and pain points"},
        "creativity": {"weight": 2, "scale": 5, "description": "Novel, non-obvious solutions"},
        "prioritization": {"weight": 2, "scale": 5, "description": "Clear framework for what to build first and why"}
      },
      "execution": {
        "structured_thinking": {"weight": 2, "scale": 5, "description": "MECE breakdown, clear metrics, tradeoff analysis"},
        "metric_definition": {"weight": 2, "scale": 5, "description": "Right success metrics identified"},
        "stakeholder_awareness": {"weight": 2, "scale": 5, "description": "Considers cross-functional dependencies"}
      }
    }
  },
  "insights": {}
}
```

`interview_prep/story_bank.json`
```json
{
  "metadata": {
    "version": "1.0",
    "last_updated": null,
    "total_stories": 0,
    "auto_generated_md": "interview_prep/story_bank.md",
    "narrative_library": "interview_prep/scripts/master_story_repository.md"
  },
  "canonical_numbers": {},
  "purged_stories": [],
  "stories": []
}
```

`config/portals.json`
```json
{
  "metadata": {
    "description": "Job board portal configurations for /scan skill",
    "portal_types": ["greenhouse", "lever", "ashby", "smartrecruiters", "custom"]
  },
  "portals": [
    {
      "company": "example",
      "name": "Example Corp",
      "type": "greenhouse",
      "board_token": "examplecorp",
      "filters": {
        "title_includes": ["product manager", "PM"],
        "title_excludes": ["project manager", "program manager"],
        "location_includes": ["Remote", "San Francisco", "New York"]
      }
    }
  ]
}
```

`config/scan_history.json`
```json
{
  "scans": []
}
```

`sources/manifest.json`
```json
{
  "processed": []
}
```

## Key Rules

- **Nothing is deleted before a verified backup exists.** Backup failure aborts the whole run.
- **Typed `RESET` only.** No yes/no confirmation.
- **Never delete what you don't recognize.** Unknown files are kept and reported.
- **Never touch system files.** Skills, hooks, settings, tools, templates, README, SETUP, LICENSE, `.gitignore`, `.git`, and `interview_prep/rubric.md` are out of scope.
- **No git operations.** No auto-commit, no push, no `git clean`. The user decides when to commit the clean state.
- **Dry run writes nothing.**
- **Skill count in CLAUDE.md Quick Start is computed, not hardcoded.**
