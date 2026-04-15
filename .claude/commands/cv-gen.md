# CV Gen — ATS-Optimized Resume Generator

Generate tailored, ATS-optimized resume PDFs per company/role. Reads the user's master resume, injects keywords from JD evaluations, reorders experience by relevance, and renders via Playwright.

## Data Files

### Read (always)
- Resume: `sources/{active_user}/resume.txt`
- Story Bank: `interview_prep/story_bank.json` (canonical numbers, proof points)
- CLAUDE.md: `CLAUDE.md` (Job Search Config, career thesis)

### Read (per company)
- Evaluation: `interview_prep/evaluations/{company}_*_eval.json` (keyword injection from Block B)
- Company Insights: `interview_prep/insights/{company}.md` (company context)
- Cheat Sheet: `interview_prep/scripts/{company}_cheat_sheet.md`

### Write
- HTML: `output/cv/{company}_resume_{date}.html`
- PDF: `output/cv/{company}_resume_{date}.pdf`

### Tools
- Template: `tools/templates/resume.html` (ATS-safe HTML template)
- PDF Generator: `tools/generate-pdf.mjs` (Playwright Chromium → PDF)
- Fonts: `tools/fonts/` (Space Grotesk + DM Sans, self-hosted WOFF2)

## Multi-Role File Keying

When generating a tailored resume, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, the output resume file is keyed `{company}_{role_slug}_resume.*`, else fall back to `{company}_resume.*` (legacy single-role). Two roles at the same company will generate two distinct resume files without overwriting each other.

## Commands

Parse `$ARGUMENTS` to determine the command:

### `<company>` — Generate Tailored Resume PDF

**Steps:**

0. **Font & size preferences (first-run prompt, persisted):**
   - Check `sources/{active_user}/resume_prefs.json`. If it exists, read it and apply the font stack + body size throughout rendering.
   - If it does not exist, ask the user three questions via AskUserQuestion:
     a. Body font (default: Calibri; other options: DM Sans, Inter, Georgia, Arial/Helvetica, or Other)
     b. Heading font (default: Match body font; options: Space Grotesk, Inter, Playfair Display, Helvetica/Arial, or Other)
     c. **Body font size in pt** (default: 11pt; options: 10pt, 10.5pt, 11pt, 11.5pt, 12pt, or Other). **NEVER ask in px.** Users think in pt (Google Docs / Word convention). Points map cleanly to printed paper.
   - Save answers to `sources/{active_user}/resume_prefs.json` in this schema:
     ```json
     {
       "body_font": "Calibri",
       "heading_font": "Calibri",
       "font_stack": "\"Calibri\", \"Helvetica Neue\", Arial, sans-serif",
       "body_size": "11pt",
       "body_size_unit": "pt",
       "heading_scale": {
         "name_h1": 2.2,
         "section_title": 1.2,
         "job_company": 1.1,
         "job_role": 1.0,
         "contact_row": 0.9
       },
       "last_updated": "YYYY-MM-DD",
       "set_by": "{active_user}"
     }
     ```
   - **CRITICAL RULES:**
     1. **Always ask size in pt, never in px.** PDFs are print artifacts; pt is the native print unit. 1pt = 1/72 inch of real paper. In CSS, 11pt renders identically across all DPI settings; 11px does not.
     2. **Body size is the ONLY size the user picks.** All heading sizes are computed via em multipliers in CSS: `font-size: 2.2em` scales automatically with body size. Never hard-code heading sizes in px or pt. Never ask the user for heading sizes.
     3. If a user provides a value in px (like "10" when they meant 10pt), ASK to confirm the unit before proceeding — don't guess. Google Docs 11 = 11pt; web "10" is ambiguous.
   - If the user wants to change prefs later, they run `/cv-gen prefs` to re-prompt.

1. **Read the user's resume** from `sources/{active_user}/resume.txt`
   - Parse sections: contact info, summary, experience, education, skills, projects

2. **Read evaluation data** from `interview_prep/evaluations/{company}_*_eval.json` (if exists)
   - Extract: keyword matches from Block B, archetype from Block A, gap list
   - If no eval exists, warn: "No evaluation found for {company}. Run `/eval` first for best keyword targeting. Generating generic tailored version."

3. **Read story bank** from `interview_prep/story_bank.json`
   - Get canonical numbers for proof points
   - Map stories to company themes

4. **Tailor the resume:**

   a. **Professional Summary** (3-4 lines):
      - Lead with the user's career thesis angle relevant to this company
      - Inject top 5 JD keywords naturally
      - Reference most relevant proof points (from story bank canonical numbers)
      - Frame around the company's archetype match

   b. **Core Competencies** (6-8 keyword tags):
      - Pull from JD requirements the user matches (score 4-5 from eval Block B)
      - Use JD's exact vocabulary where the user has the experience
      - Example: JD says "RAG pipelines" + user has hybrid search experience → "RAG Pipeline Design & Retrieval Architecture"

   c. **Work Experience**:
      - Reorder bullet points by relevance to this JD (most relevant first per role)
      - Inject JD keywords into existing bullet points where truthful
      - Ensure canonical numbers are exact (from story_bank.json)
      - Top 3-4 bullets per role, most impactful first

   d. **Key Projects**:
      - Select top 3-4 most relevant to this JD
      - Reframe descriptions to connect to JD requirements

   e. **Education & Skills**:
      - Keep as-is from master resume (MBA from Carnegie Mellon)
      - Ensure skills section includes JD keyword matches

5. **Generate HTML:**
   - Read `tools/templates/resume.html`
   - Replace all `{{PLACEHOLDER}}` values. Typography placeholders come from `resume_prefs.json`; DO NOT hard-code font sizes or family names:
     - `{{LANG}}` → "en"
     - `{{PAGE_WIDTH}}` → "8.5in" (letter) or "210mm" (A4)
     - `{{FONT_FACE_IMPORTS}}` → if the chosen font is a Google/web font, inject `@import url('https://fonts.googleapis.com/css2?family=...')` or `@font-face` blocks. For system fonts (Calibri, Georgia, Arial), leave empty.
     - `{{FONT_STACK}}` → e.g. `"Calibri", "Helvetica Neue", Arial, sans-serif` (from prefs)
     - `{{BODY_SIZE}}` → e.g. `10px`, `11px` (from prefs; this is the ONLY size placeholder — all headings scale via `em` in CSS)
     - `{{NAME}}` → from resume header
     - `{{CONTACT_ROW}}` → HTML for email / phone / LinkedIn / website / location, separated by `<span class="separator">&bull;</span>`
     - `{{SUMMARY_TEXT}}` → tailored summary
     - `{{COMPETENCIES_SECTION}}` → either a full `<div class="section">...` block with competency tags, OR an empty string to omit
     - `{{EXPERIENCE}}` → HTML for each job (use `.job`, `.job-header`, etc. classes)
     - `{{PROJECTS_SECTION}}` → either a full Projects section block, OR an empty string to omit
     - `{{EDUCATION}}` → HTML for education
     - `{{SKILLS}}` → HTML for skills line or grid
   - Write to `output/cv/{company}_resume_{date}.html`

**Heading scaling reference (em-based in CSS, do not override). All values in pt (the print-native unit):**
| Element | em multiplier | At 10pt body | At 11pt body | At 12pt body |
|---|---|---|---|---|
| Name (H1) | 2.2em | 22pt | 24.2pt | 26.4pt |
| Section title | 1.2em | 12pt | 13.2pt | 14.4pt |
| Job company | 1.1em | 11pt | 12.1pt | 13.2pt |
| Job role | 1.0em | 10pt | 11pt | 12pt |
| Contact row | 0.9em | 9pt | 9.9pt | 10.8pt |
| Job period | 0.9em | 9pt | 9.9pt | 10.8pt |
| Body li/summary/skills | 1.0em | 10pt | 11pt | 12pt |

6. **Preview HTML to user BEFORE generating PDF (mandatory):**
   - After writing the HTML file, auto-open it in the user's default browser:
     - Windows: `start "" "output/cv/{company}_resume_{date}.html"`
     - macOS: `open output/cv/{company}_resume_{date}.html`
     - Linux: `xdg-open output/cv/{company}_resume_{date}.html`
   - Also show the rendered Summary section and Experience headers as a text preview inline (for users who don't see the browser).
   - Ask: "Does this look right? Any edits before I render the PDF? (PDF generation is compute-heavy; let's get the content right first.)"
   - Only proceed to step 7 (PDF generation) AFTER user explicitly approves the HTML content.
   - If user requests edits, apply them to the HTML file and re-preview. The browser tab auto-refreshes on file change if user has the tab open.

7. **Generate PDF (only after HTML approval):**
   - Run: `node tools/generate-pdf.mjs output/cv/{company}_resume_{date}.html output/cv/{company}_resume_{date}.pdf --format=letter`
   - If command fails (Playwright not installed), inform user:
     "PDF generation failed — Playwright may not be installed. Run `cd tools && npm install && npx playwright install chromium` to set up."
     "In the meantime, open the HTML file in Chrome and Print → Save as PDF."

8. **Display result:**

## CV GENERATED — {COMPANY}

- **PDF:** `output/cv/{company}_resume_{date}.pdf`
- **HTML:** `output/cv/{company}_resume_{date}.html`
- **Pages:** {N} | **Size:** {N} KB

---

### Tailoring Summary

- **Archetype:** {detected archetype}
- **Keywords injected:** {N} ({list top 5})
- **Summary reframed:** {angle used}
- **Experience reordered:** {which bullets moved up}

---

### Keyword Coverage

| JD Keyword | In Resume? | Section |
|-----------|-----------|---------|
| {keyword} | Yes | Summary + Experience |
| {keyword} | Yes | Competencies |
| {keyword} | No (gap) | -- |

8. Offer: "Run `/save-push` to save?"

---

### `prefs` — Re-Prompt Font & Size Preferences

Re-run the Step 0 prompts from the main command and overwrite `sources/{active_user}/resume_prefs.json`. Use when the user wants to change font or base size. Does NOT regenerate any existing resume; next `/cv-gen <company>` run will pick up the new prefs.

### `<company> --preview` — HTML Preview Only

Same as above but skip step 6 (PDF generation). Useful when Playwright isn't installed.

Display the HTML file path and suggest opening in browser.

---

### `list` — Show All Generated CVs

List all files in `output/cv/`, sorted by date descending.

## GENERATED CVs

| Date | Company | Format | Size |
|------|---------|--------|------|
| {date} | {company} | PDF | {N} KB |
| {date} | {company} | PDF | {N} KB |

**Total:** {N} resumes generated

---

## ATS Optimization Rules

- **Single-column layout** — no sidebars, no tables for layout. ATS parsers read top-to-bottom.
- **Standard section headers**: Professional Summary, Core Competencies, Work Experience, Key Projects, Education, Skills. ATS recognizes these.
- **No text in images/SVGs** — everything is selectable HTML text.
- **UTF-8** — no special encodings.
- **Keywords distributed**: Summary (top 5 keywords), first bullet per role (2-3 keywords), Competencies (6-8 keyword phrases), Skills section.
- **Never invent skills or experience.** Only inject keywords where the user genuinely has the experience. Reform existing bullets with JD vocabulary, don't fabricate.

## Keyword Injection Ethics

Reform real experience with JD vocabulary. Pattern:
- JD says "X", user has adjacent experience Y, reframe user's bullet as "X using Y context" (preserving truth and user's canonical numbers)

**NEVER** add skills the user does not have. If a JD keyword has no match, leave it out.

## Key Rules

- **Canonical numbers from story_bank.json** — always exact, never rounded
- **Education**: pull exactly from the user's master resume; never invent or swap degree types.
- **Resume must be 1-2 pages max.** If it exceeds 2 pages, cut less relevant content.
- **Design**: Space Grotesk headings, DM Sans body. Cyan section headers, purple company names. Clean, professional.
- **Letter format default** (US market). Use A4 only if targeting non-US roles.

## Integration with Other Skills

### Receives From
- `/eval` — evaluation JSON provides keywords, archetype, and gap data
- `/auto-pipe` — orchestrates cv-gen as part of the pipeline

### Cross-References in Output
- "→ /eval {company}" if no evaluation exists
- "→ /save-push" to save
