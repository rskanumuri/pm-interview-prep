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
- HTML: `output/cv/{company}_{active_user}_{date}.html`
- PDF: `output/cv/{company}_{active_user}_{date}.pdf`

### Tools
- Template: `tools/templates/resume.html` (ATS-safe HTML template)
- PDF Generator: `tools/generate-pdf.mjs` (Playwright Chromium → PDF)
- Fonts: `tools/fonts/` (self-hosted WOFF2)

## Multi-Role File Keying

When generating a tailored resume, follow the `{company_key}` convention documented in `CLAUDE.md` under "Multi-Role File Keying". Accept an optional `<role>` arg; when provided, the output resume file is keyed `{company}_{role_slug}_resume.*`, else fall back to `{company}_resume.*` (legacy single-role). Two roles at the same company will generate two distinct resume files without overwriting each other.



Parse `$ARGUMENTS` to determine the command:

### `<company>` — Generate Tailored Resume PDF

**Steps:**

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
      - Reference most relevant proof points (use canonical numbers from story_bank.json)
      - Frame around the company's archetype match

   b. **Core Competencies** (6-8 keyword tags):
      - Pull from JD requirements that user matches (score 4-5 from eval Block B)
      - Use JD's exact vocabulary where the user has the experience
      - Reform real experience with JD vocabulary

   c. **Work Experience**:
      - Reorder bullet points by relevance to this JD (most relevant first per role)
      - Inject JD keywords into existing bullet points where truthful
      - Ensure canonical numbers are exact (from story_bank.json)
      - Top 3-4 bullets per role, most impactful first

   d. **Key Projects**:
      - Select top 3-4 most relevant to this JD
      - Reframe descriptions to connect to JD requirements

   e. **Education & Skills**:
      - Keep as-is from master resume
      - Ensure skills section includes JD keyword matches

5. **Generate HTML:**
   - Read `tools/templates/resume.html`
   - Replace all `{{PLACEHOLDER}}` values:
     - `{{LANG}}` → "en"
     - `{{PAGE_WIDTH}}` → "8.5in" (letter) or "210mm" (A4)
     - `{{NAME}}`, `{{EMAIL}}`, `{{LINKEDIN_URL}}`, `{{LINKEDIN_DISPLAY}}`, `{{LOCATION}}` → from resume
     - `{{SUMMARY_TEXT}}` → tailored summary
     - `{{COMPETENCIES}}` → `<span class="competency-tag">{keyword}</span>` per tag
     - `{{EXPERIENCE}}` → HTML for each job (use `.job`, `.job-header`, etc. classes)
     - `{{PROJECTS}}` → HTML for selected projects
     - `{{EDUCATION}}` → HTML for education
     - `{{SKILLS}}` → HTML for skills grid
   - Write to `output/cv/{company}_{active_user}_{date}.html`

6. **Generate PDF:**
   - Run: `node tools/generate-pdf.mjs output/cv/{company}_{active_user}_{date}.html output/cv/{company}_{active_user}_{date}.pdf --format=letter`
   - If command fails (Playwright not installed), inform user:
     "PDF generation failed — Playwright may not be installed. Run `cd tools && npm install && npx playwright install chromium` to set up."
     "In the meantime, open the HTML file in Chrome and Print → Save as PDF."

7. **Display result:**

## CV GENERATED — {COMPANY}

- **PDF:** `output/cv/{company}_{active_user}_{date}.pdf`
- **HTML:** `output/cv/{company}_{active_user}_{date}.html`
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

### `<company> --preview` — HTML Preview Only

Same as above but skip step 6 (PDF generation). Useful when Playwright isn't installed.

Display the HTML file path and suggest opening in browser.

---

### `list` — Show All Generated CVs

List all files in `output/cv/`, sorted by date descending.

## GENERATED CVs

| Date | Company | Format | Size |
|------|---------|--------|------|
| 2026-04-06 | {Company} | PDF | 48 KB |
| 2026-04-05 | {Company} | PDF | 52 KB |
| 2026-04-01 | {Company} | HTML | -- |

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

Reform real experience with JD vocabulary. Examples:
- JD "cloud platform management", User "IaaS product" → "Cloud platform product management (IaaS — [canonical ARR])"
- JD "AI/ML pipelines", User "hybrid search" → "AI/ML pipeline architecture and retrieval optimization ([canonical F1 score])"
- JD "enterprise GTM", User "marketplace" → "Enterprise GTM and marketplace strategy ([canonical revenue])"

**NEVER** add skills the user doesn't have. If a JD keyword has no match, leave it out — don't force it.

## Key Rules

- **Canonical numbers from story_bank.json** — always exact, never rounded
- **Education from resume** — use exactly as stated, never embellish
- **Resume must be 1-2 pages max.** If it exceeds 2 pages, cut less relevant content.
- **Design**: Clean, professional. Readable fonts. Section headers clearly delineated.
- **Letter format default** (US market). Use A4 only if targeting non-US roles.

## Integration with Other Skills

### Receives From
- `/eval` — evaluation JSON provides keywords, archetype, and gap data
- `/auto-pipe` — orchestrates cv-gen as part of the pipeline

### Cross-References in Output
- "→ /eval {company}" if no evaluation exists
- "→ /save-push" to save
