# Skills Core (shared rules)

Skills point here instead of repeating these rules. Where a skill conflicts with this file, this file wins. Debrief-specific rules stay in `debrief_core.md`.

## 1. Clock and schedule check

Run this at the start of any skill that prepares for, drills for, or reports on a scheduled interview (`/prep-check`, `/tmay`, `/drill-rapid`, `/interview-prep`, `/battle-plan`, `/pipeline`).

1. Get the current date and time from the system clock. Never assume it and never ask the user for it.
2. Read `interview_prep/progress.json` `interview_dates.{company_key}`.
3. If mail or calendar tools are connected, look for the most recent invite or update for that company and compare. Recruiters reschedule; the newest invite wins. If the two disagree, say so and ask before changing anything.
4. Print one line before anything else: `Interview: {weekday, date, time, timezone} ({in N hours / in N days / PAST})`. If no date is recorded, print `Interview: no date recorded` and ask for it once.
5. If the interview is under 2 hours away, switch to the short form of the skill (quick card, one rep) and say so.
6. A skill that is allowed to write state updates `interview_dates` when the date is new or changed (show the before and after first). A read-only skill only reports the mismatch.

Format for `interview_dates` values: ISO local date and time plus timezone and a short label, for example `"{YYYY-MM-DD}T11:00 PT, recruiter screen, {interviewer}"`. One key per role (`{company_key}`), overwritten when the next round is scheduled; past rounds live in debriefs.

## 2. Writing JSON state files

Applies to `progress.json`, `applications.json`, `story_bank.json`, `companies.json`, `upstream_sync.json`, evaluation JSON files.

1. Change only the keys the skill owns. Never re-serialize a whole file: a parse-and-dump rewrites indentation, key order and escapes and produces a diff of hundreds of lines. Insert or replace text at the exact location instead.
2. Keep the file's existing line endings (some files are CRLF, some LF) and encoding (UTF-8, no escaping of non-ASCII).
3. After the edit, parse the file to confirm it is still valid JSON. If it is not, restore it and stop.
4. Check `git diff --stat` for the file. If the changed-line count is far larger than the edit, undo and redo it as a text insertion.
5. Show the before and after and wait for a yes before writing shared state, except for files the skill is creating.
6. When several files change in one step, make every edit safe to re-run or check all preconditions before the first write, so a failure halfway does not leave half the files updated.
7. On Windows, run helper scripts with UTF-8 output forced; the default console encoding fails on arrows and other non-ASCII characters.

## 3. File keys and where files live

- `{company_key}` = `{company}_{role_slug}` when a role is given, else `{company}` (legacy). `role_slug` = role lowercased, non-alphanumeric to underscores, collapsed; a shortened sane slug is allowed and then kept. Full rule: CLAUDE.md "Multi-Role File Keying". Lookups try the role-keyed name first, then the company-only name.
- Every file a skill writes for a company carries `{company_key}` in its name, including files under `interview_prep/research/`. Close-out finds files by that key (`/pipeline drop`).
- Live prep sits under `interview_prep/` (scripts, insights, rubrics, evaluations, answers, research). When a company closes, everything moves to `sources/{company}/`. A skill looking for a closed company's rubric, insights or debriefs looks there.
- Transcripts and intel files in `sources/{company}/` open with a `**Source:**` line and are never edited after the fact.

## 4. Active user

Read `progress.json` `active_user`. Personal material comes only from `sources/{active_user}/` and `interview_prep/story_bank.json`. Never show stories that belong to another user (for example a shared `star_stories.json` that holds someone else's stories).

## 5. Numbers and stories come from canon

- Values: `story_bank.json` `canonical_numbers`. Meaning and allowed wording: `canonical_provenance`. Never-use list: `purged_stories`.
- No skill keeps its own copy of the numbers, and templates use placeholders such as `{headline number}`, not example figures, because an example can be copied into output.
- Any skill that shows the user text to internalize or deliver (TMAY, drills, cheat sheets, practice feedback, application answers) runs the canon check first and prints drift above the text.
- A recall or timeline file that quotes source documents on purpose is exempt from fixing and is labeled as such in its header.

## 6. Pre-interview rules (the penalty list)

1. Lead with business impact, not technology.
2. Never introduce a story with what you lack.
3. Never frame a current or recent role as a consolation prize.
4. "Can AI make it faster?" test: if a generic answer could replace it, be more specific.
5. End with an offer or closing questions.
Each violation is -1 in debriefs and `/pm-practice`. A rubric row must not penalize the same behavior again (`debrief_core.md` §1).

## 7. Writing style in generated files

- No em dashes or en dashes in content written for the user (headers, scripts, debriefs, notes). Use a colon, comma, parentheses or a new sentence. Output templates in the skills and in `interview_prep/reference/skill_templates/` use a colon in headings. The instruction prose inside skills still uses dashes; that prose is not output. If a template line with a dash was missed, write a colon or comma in the output anyway. A dash standing alone in a table cell means "empty" and is fine. Hyphenated words and date ranges are fine. Resume-specific exceptions are in `/cv-gen`.
- Scripts are written to be spoken: short sentences, contractions, no resume-bullet phrasing.
- Long content uses headers, bold and bullets, not code blocks.
- Quotes from a transcript are exact; anything recalled is labeled as recalled.

## 8. Agents and models

- Default is inline: do the research or analysis in the main session. Start a background agent only when the user asks for one (for example by running `/timed-research`) or the skill is explicitly an agent launcher.
- Judgment work (scoring, debrief analysis, fit, story integrity, coaching) stays in the main session on the session's own model. Gathering and organizing work may run on a cheaper model when an agent is used. Do not hard-code model names in skills; they go out of date.
- Background agents write their output file early and keep enriching it, and never commit or push.
