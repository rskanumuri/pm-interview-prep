# Setup Guide

## Recommended: Use the Wizard

The fastest way to set up is the interactive wizard:

```
claude
/setup
```

It reads your resume, extracts your stories and metrics, and configures everything in ~5 minutes. You can also try `/setup --demo` to explore with sample data first.

---

## Manual Setup (Alternative)

If you prefer to configure manually:

### 1. Prerequisites

- [Claude Code](https://claude.ai/code) installed
- Node.js (optional, for PDF resume generation)

```bash
# Optional: install PDF tools
cd tools && npm install && cd ..
```

### 2. Create Your Profile

```bash
# Rename the placeholder folder to your name
mv sources/your_name sources/jane

# Add your resume (plain text)
# Copy your resume content into sources/jane/resume.txt
```

### 3. Set Active User

Edit `interview_prep/progress.json`:
```json
{
  "active_user": "jane",
  "start_date": "2026-04-10"
}
```

### 4. Configure CLAUDE.md

Edit `CLAUDE.md` and fill in:
- **Career Thesis** — One sentence that threads through all your stories
- **Key Numbers** — Your 4-6 headline impact metrics
- **Comp Targets** — Base, total comp, visa requirements
- **Location** — Where you want to work
- **Target Archetypes** — PM role types you're strongest for
- **Story Integrity** — Your canonical numbers that must never be misquoted

### 5. Seed Your Story Bank

```
/story-bank add "My Best Project"
```

Repeat for 3-5 core stories. Or run `/setup` later to auto-extract from your resume.

### 6. Start Using

```
/eval <paste a JD>          # Evaluate a role
/company-prep <name>        # Research a target company
/pm-practice <company>      # Practice interview questions
```

---

## After Your First Interview

```
/debrief-live <company> <interviewer>
```

Paste your transcript or notes. The system scores your performance, extracts lessons, and updates your story bank.

---

## Getting Help

- Type `/pipeline` to see your full interview dashboard
- Type `/battle-plan` to plan your daily prep
- Type `/setup status` to check your configuration
- See `README.md` for the full command reference
