# PM Interview Prep System

AI-powered interview preparation for Product Managers. 26 slash commands covering the full lifecycle: job discovery, company research, story management, mock interviews, and post-interview debrief.

## The Operating Principle

**Interviews are research, not performance.** The questions you're asked compound across rounds. The answers you gave don't. This system is built to capture questions, patterns, and wisdom so each interview makes the next one easier.

## Get Started

```
git clone https://github.com/YOUR_USERNAME/pm-interview-prep.git
cd pm-interview-prep
claude
```

Then type:

```
/setup
```

That's it. The wizard reads your resume, extracts your stories and metrics, preps your first company, and configures everything in about 5 minutes.

## What It Does

| Phase | Commands |
|-------|----------|
| **Discover** | `/scan` `/eval` `/auto-pipe` |
| **Apply** | `/apply` `/cv-gen` |
| **Research** | `/research` `/timed-research` `/company-prep` `/process-sources` |
| **Prepare** | `/interview-prep` `/fit-check` `/phantom` `/story-map` `/story-bank` `/story-check` `/steelman` `/tmay` `/prep-check` `/battle-plan` |
| **Practice** | `/pm-practice` `/drill-rapid` |
| **Debrief** | `/debrief` `/debrief-live` |
| **Track** | `/pipeline` `/save-push` `/setup` |

## How It Works

- **`CLAUDE.md`**. Your brain file. Career thesis, canonical numbers, interview rules. Claude reads this every session.
- **`/setup`**. One-time setup wizard. Reads your resume, seeds your story bank, builds your first company prep.
- **26 skills**. Specialized workflows in `.claude/commands/`. Each handles one part of the interview lifecycle.
- **Hooks**. Agent time enforcement. Background research auto-stops after the time budget.
- **Data files**. JSON state (`story_bank.json`, `progress.json`, `companies.json`). Skills read and write these to maintain continuity across sessions.

## Requirements

- [Claude Code](https://claude.ai/code) with a Claude Pro, Team, or Enterprise subscription
- Node.js (optional, for PDF resume generation via `/cv-gen`)

## Optional Integrations

- **Granola**. Auto-pull interview transcripts for `/debrief-live`
- **Gamma**. Generate presentation decks

Both are optional. All core workflows work without them.

## License

MIT
