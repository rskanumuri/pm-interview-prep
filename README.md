# PM Interview Prep

A PM-specific job-search and interview system, built on Claude Code. Full funnel, scan to debrief, with the interview rounds as the center of gravity.

It's Sunday, 9pm. You found the JD you actually want. You don't have three hours tonight to tailor a resume, research the company, and draft a cold email. You bookmark it. You don't come back.

Or you paste it into `/fit-check` right now. Two minutes later you know if it's worth pursuing. Fifteen minutes after that, you have a full prep folder: cheat sheet, rubric, competitive intel, why-script, gap answers.

## Demo

```
> /fit-check Acme "Senior PM, Data Governance" <paste JD>

4.1 / 5, STRONG FIT. Pursue.
Bridges: platform builder, RBAC/governance depth, cross-org GTM.
Gap: hands-on data lineage (MEDIUM, adjacent not direct).
```

A go/no-go verdict with reasons, not a gut call. From there, `/company-prep` builds the rest of the prep folder. `/phantom` sketches the 10/10 reference candidate so you have a bar to calibrate against instead of guessing.

## What makes this different

**The phantom.** A composite of the strongest candidate the hiring team could realistically hope to see for this role. Your prep sharpens against an actual yardstick, not a vibe.

**Canonical numbers lock.** Your metrics, once set, are frozen. The system blocks drift ("I think it was around 80M...") and blocks purged stories before either reaches an interview room.

**Stage-aware prep.** Recruiter screens get a cheat sheet. HM screens get gap analysis, domain glossary, and a problem-first script. Loops get per-interviewer scripts and a pre-mortem. Never over- or under-prepped for the round you're in.

**Everything syncs.** Monday's debrief updates the story bank, the question bank, the rubrics, and the phantom. By Wednesday, when you prep for a different company, the system is already using Monday's lessons. You never re-learn the same thing.

**Live debriefs on your practice sessions.** Optional Granola integration auto-pulls transcripts from mock interviews and coach sessions. `/debrief-live` scores the session against a company rubric, extracts what landed vs didn't, updates your story bank, and proposes lessons. Five minutes, not an hour of notes. (Recording real interviews is frowned upon; use `/debrief` for those, where you answer guided questions from memory.)

## Full funnel coverage

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

26 commands. Top-of-funnel (Discover, Apply) covers what tools like [career-ops](https://github.com/santifer/career-ops) do at industrial scale. The depth advantage lives in Strategize / Craft / Practice / Debrief: the interview rounds themselves.

## Start

Requires Claude Code with a Pro, Team, or Enterprise plan.

```
cd pm-interview-prep
claude
```

Inside Claude Code:

```
/setup
```

A 5-minute wizard reads your resume, extracts your stories and canonical numbers, and seeds your first target company. Or try `/setup --demo` with a synthetic profile to explore first.

Prefer manual setup? See [SETUP.md](SETUP.md).

## Under the hood

Every skill is a markdown prompt in `.claude/commands/`. Read, edit, fork. State lives in `interview_prep/*.json` and persists across sessions. Nothing leaves your machine. Your git repo is the database.

## Optional integrations

- **Granola** auto-pulls transcripts from your mock interviews and coach sessions for `/debrief-live`. Without it, paste transcripts manually. Do not record actual interviews; use `/debrief` (guided questions from memory) for those.
- **Gamma** generates presentation decks for loop prep.

Both optional. All core workflows work without them.

## License

[MIT](LICENSE)
