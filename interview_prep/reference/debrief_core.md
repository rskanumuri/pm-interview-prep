# Debrief Core (shared by `/debrief` and `/debrief-live`)

Both debrief commands read this file first. Anything here overrides a conflicting line in either command.

## 0. Transcripts are the record (the project's transcript-handling rule)

Before any analysis:

1. **Look locally first.** Glob `sources/<company>/*transcript*` for this interviewer and date. If a transcript already exists, use it. Do NOT call Granola.
2. **Only if none exists locally**, and a Granola meeting is identified (title, date, or id), pull it with the Granola MCP and save it.
3. **Save the full verbatim transcript** to `sources/<company>/<interviewer>_<type>_transcript_<YYYY-MM-DD>.md` (match the naming already used in that company folder if it differs). No summaries, no cleanup, no paraphrase. The first lines are `**Source:** <channel + attendees + date>` (for example, "Granola, {interviewer} HM screen, {date}" or "pasted by the user, {date}").
4. **`/debrief-live`:** the pasted text IS the transcript. Save it verbatim before scoring. If the paste is notes or a recruiter relay, not a transcript, save it as `<interviewer>_notes_<date>.md` and say so in the debrief header.
5. **`/debrief` (interactive):** if no transcript exists anywhere, state "no transcript; the user's recollection only" in the debrief header and cap confidence accordingly. Never present recalled quotes as verbatim.
6. **Never overwrite or edit an existing transcript or debrief.** If the target filename exists, add a suffix (`-2`, `-live`). Old values in old files were true when written; fix forward-looking files only.
7. Do the save before analysis, and report the saved path in the final report.

## 1. Scoring (replaces the generic dimension tables in both commands)

- **Use the company rubric**: `interview_prep/rubrics/{company_key}.md`, else `sources/<company>/rubric.md`, else the master `interview_prep/rubric.md`. Say which was used. If only the generic six-dimension fallback is available, label it "unweighted, generic" and do not compare it to rubric-scored rounds.
- **Weights**: universal dimensions (Delivery, Company Fit) count 1x; format-specific dimensions count 2x, per the scoring rules in CLAUDE.md.
- **Penalty**: apply -1 for each violated pre-interview rule (lead with impact, no lack-framing, no framing a previous employer as a consolation prize, "can AI make it faster" test, end with offer/closing questions). Name the rule.
- **Overall = the weighted rubric score after penalties.** It is NOT the user's self-score. Record both in the header: `Overall (rubric-strict): X.X/5 | Self-score: Y.Y/5`. This is what "rubric-strict" means everywhere.
- **Not attempted is not N/A.** If a rubric row was expected and never came up, score it as unattempted (counts as 2.0 unless the rubric says otherwise) and say "not attempted". Do not drop it from the average.
- **Flag**: any round under 3.0 is flagged for review in the report.
- **Evidence rule**: every dimension score cites a quote or moment from the transcript. No quote available means "no evidence", not an invented one.
- **Number accuracy check**: compare every canonical number the user said (the story-integrity rules and `story_bank.json` `canonical_numbers` / `canonical_provenance`) against canon. List drift in "What Didn't Land".

## 2. Story angles go to `story_bank.json`

`interview_prep/story_bank.json` is canonical. `master_story_repository.md` is the narrative library, not the index.

- For each story told, update `company_angles[company]` in `story_bank.json`: add `tested` (round label) and `score`. If a prior `tested`/`score` exists, keep it and append the new round as an additional entry. Never reset a tested angle to "No".
- Add to `performance.interviews[]` and bump `times_told` once per telling.
- If the framing was meaningfully new, offer to add it to `angles[]` (see `/story-bank` "Angle Extraction").
- Offer (do not auto-do) the mirror edit to the Company-Specific Angles table in `master_story_repository.md`.
- Check each story against `purged_stories` and `canonical_provenance`. If the user told a purged story, or told a number outside its provenance ruling, flag it.
- After edits, offer `/story-bank refresh` to regenerate `story_bank.md`. Never hand-edit it.

## 3. Writes need a diff and a yes

Before changing any shared state, show the exact before/after and wait for confirmation:

- The Stage cell in the CLAUDE.md pipeline row (single cell only; never rewrite the row).
- `interview_prep/progress.json` (touch only the keys for this company and this session; never reformat the file).
- `interview_prep/session_data.json` is a stale cache; do not "keep it in sync" and do not regenerate it here.

The new debrief file itself is a create, not an overwrite, so it can be written without a diff. Do NOT auto-run `/save-push`; offer it. (CLAUDE.md Git Behavior: offer to save and push after file writes.)

## 4. Career-learning hooks (both commands)

After the report, run all four. Propose, show, and write only after the user confirms.

1. **Interview lessons**: compare this round's misses to `interview_prep/interview_lessons.md` "Still Learning". Update evidence lines, propose moves to "learned" only after 3 clean rounds, propose new patterns.
2. **Career takeaway**: if rubric-strict is 3.0 or lower, or the round ended in rejection, propose a takeaway for `interview_prep/career_takeaways.md` extracted from the debrief. Do not ask the user to write it.
3. **Question bank**: add new questions to `interview_prep/question_bank.md`, then regenerate `question_bank_clean.md` by stripping company names, interviewer names, scores and personal notes. After regenerating, grep the clean file for every company and interviewer name in this debrief and in `companies.json`; if any appears, fix it before reporting. Report "Added N new, updated N existing, total M".
4. **Phantom**: if `interview_prep/scripts/{company_key}_phantom.md` exists, offer to sharpen it with the debrief's New Intel. Never edit phantoms for closed roles except to append a post-mortem.

## 5. Filenames

`interview_prep/answers/{company_key}_{interviewer_firstname}_debrief_{YYYY-MM-DD}.md` (lowercase, underscores), role-keyed per the Multi-Role File Keying convention. If it exists, suffix `-2`; `/debrief-live` uses `-live` when a `/debrief` file exists for the same interviewer and date.
