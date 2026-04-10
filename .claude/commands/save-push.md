# Save & Push to Git Remote

One-command workflow that stages, commits, and pushes all changes to git remote. Eliminates the need to say "save everything to git remote" repeatedly.

## Behavior

When invoked with `/save-push`, perform ALL of the following in sequence:

### Step 1 — Detect Changes

Run `git status` to identify:
- Modified tracked files
- Untracked files (new files that should be added)
- Staged files

If there are NO changes (working tree clean), report:
```
Nothing to save — working tree clean.
```
And stop.

### Step 2 — Stage All Relevant Files

Stage all modified and new files. Exclude:
- `.env`, `credentials.json`, or any file likely containing secrets
- `node_modules/`, `.DS_Store`, `__pycache__/`
- Files already in `.gitignore`

Use `git add` with specific file paths (not `git add -A`). List the files being staged.

### Step 3 — Generate Commit Message

Analyze the staged changes and generate a concise commit message that:
- Summarizes WHAT changed (not HOW)
- Uses present tense ("update X", "add Y", "fix Z")
- Is 1 line, under 72 characters
- Ends with `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>`

### Step 4 — Commit and Push

1. Create the commit
2. Push to the current remote tracking branch (usually `origin main`)
3. If push fails due to no upstream, set upstream with `git push -u origin {branch}`

### Step 5 — Report

**Saved & pushed ({N} files)**
- {commit hash short} — {commit message}
- {list of files changed, max 10, with "and N more" if >10}

## Arguments

Parse `$ARGUMENTS`:

- No arguments: Stage everything, auto-generate commit message
- `"message here"`: Use the provided text as commit message
- `--dry`: Show what would be committed without actually committing

## Key Rules

- NEVER skip git hooks (no --no-verify)
- NEVER force push
- NEVER commit files that look like secrets
- If there are merge conflicts, report them and stop — don't try to resolve
- Always create a NEW commit, never amend
- This skill should be FAST — no unnecessary reads or analysis
