# PM Interview Prep

A Claude Code workspace where your resume, stories, and company research accumulate across interviews. Each round is easier than the last.

## Start

**Requires:** [Claude Code](https://claude.ai/code) with a Pro, Team, or Enterprise plan.

```
git clone https://github.com/YOUR_USERNAME/pm-interview-prep.git
cd pm-interview-prep
claude
```

Inside Claude Code, type:

```
/setup
```

A 5-minute wizard. Paste your resume, answer a few questions, and watch it research your first target company live.

## Just Want to See It First?

```
/setup --demo
```

Same flow with a sample profile and real web research on a public company (Stripe, Notion). When you're ready for the real thing:

```
/setup reset
/setup
```

## Your First 10 Minutes After /setup

```
/tmay <company>          Practice Tell Me About Yourself, framed for a target
/eval <paste a JD>       Score a job description in 2 minutes
/pm-practice <company>   Take a practice question with scored feedback
```

That's enough to feel how the system works. The other 23 commands compound on top: story refinement, mock interviews, live debriefs, pipeline tracking.

## All 26 Commands

| Phase | Commands |
|-------|----------|
| **Discover** | `/scan` `/eval` `/auto-pipe` |
| **Apply** | `/apply` `/cv-gen` |
| **Research** | `/research` `/timed-research` `/company-prep` `/process-sources` |
| **Strategize** | `/fit-check` `/phantom` `/story-map` `/battle-plan` `/prep-check` |
| **Craft** | `/story-bank` `/story-check` `/steelman` `/tmay` `/interview-prep` |
| **Practice** | `/pm-practice` `/drill-rapid` |
| **Debrief** | `/debrief` `/debrief-live` |
| **Track** | `/pipeline` |
| **Workspace** | `/setup` `/save-push` |

## Under the Hood

- **`CLAUDE.md`** — Your brain file. Career thesis, canonical numbers, rules. Claude reads it every session.
- **Skills** in `.claude/commands/` — 26 specialized workflows.
- **State** in `interview_prep/*.json` — Story bank, pipeline, progress. Persists across sessions.

Prefer manual setup? See [SETUP.md](SETUP.md).

## Optional Integrations

- **Granola** — Auto-pull interview transcripts for `/debrief-live`
- **Gamma** — Generate presentation decks

Both are optional. All core workflows work without them.

## License

[MIT](LICENSE)
