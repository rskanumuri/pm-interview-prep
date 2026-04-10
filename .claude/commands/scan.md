# Scan — Portal Scanner for PM Roles

Scan company career pages and job boards for PM roles matching your target archetypes. Uses WebFetch to pull career pages, title-filters results, deduplicates against existing applications, and adds new discoveries to the pipeline.

## Data Files

### Read (always)
- Portals Config: `config/portals.json` (portal list + filter defaults)
- Applications: `interview_prep/applications.json` (dedup against existing)
- Scan History: `config/scan_history.json` (dedup against prior scans)
- CLAUDE.md: `CLAUDE.md` (Job Search Config — archetypes, preferences)

### Write
- Applications: `interview_prep/applications.json` (add discovered roles)
- Scan History: `config/scan_history.json` (log scan results)
- Portals Config: `config/portals.json` (on `add` command)

## Commands

Parse `$ARGUMENTS` to determine the command:

### *(no args)* — Scan All Portals

Scan every portal in `config/portals.json` for new PM roles.

**Steps:**

1. **Read config files:**
   - `config/portals.json` for portal list and filter defaults
   - `interview_prep/applications.json` for existing applications (dedup)
   - `config/scan_history.json` for prior scan results (dedup)

2. **For each portal in portals.json:**
   a. Fetch the career page URL via WebFetch
   b. Parse the response for job listings:
      - **Greenhouse** (`job-boards.greenhouse.io/{slug}`): Parse JSON API at `https://boards-api.greenhouse.io/v1/boards/{slug}/jobs` — returns structured JSON with title, location, URL per job
      - **Lever** (`jobs.lever.co/{slug}`): Parse HTML for job listing cards
      - **Ashby** (`jobs.ashbyhq.com/{slug}`): Parse HTML/JSON for listings
      - **Custom**: Parse HTML for role listings — look for links containing keywords like "product", "PM", "career"
   c. For each listing found:
      - **Title filter**: Check against `scan_defaults.title_include` (case-insensitive, must match at least one). Reject if matches `scan_defaults.title_exclude`.
      - **Location filter**: If location data available, check against `scan_defaults.location_include` (case-insensitive). Skip filter if no location data.
      - **Dedup**: Skip if URL or (company + normalized role title) already exists in `applications.json` or `scan_history.json`
   d. Collect all new matches

3. **For each new match:**
   - Add to `interview_prep/applications.json` with status `discovered`
   - Add to `config/scan_history.json` with scan date and status

4. **Display results:**

## SCAN RESULTS — {date} — {N} portals scanned

---

### New Roles Found ({N})

- **{Company}** | {Role Title} | {Location}
  - {url}
  - Added to pipeline as "discovered"

---

### Skipped ({N})

- {Company} — {Role} — duplicate (already in pipeline)
- {Company} — {Role} — title filter (excluded: "project manager")

---

### Scan Summary

- **Portals scanned:** {N}/{total}
- **Listings found:** {N}
- **After title filter:** {N}
- **After dedup:** {N} new
- **Failed portals:** {N} (list if any)

---

### Next Steps

{N} new roles discovered. Run `/eval` on the most promising ones:
- `/eval {url1}`
- `/eval {url2}`
- Or batch evaluate all: `/eval batch`

5. Offer: "Run `/save-push` to save scan results?"

---

### `<company>` — Scan Single Portal

Scan one specific company's career page.

**Steps:**
1. Find company in `config/portals.json`
2. If not found, offer: "Add {company} to portals? Provide career page URL."
3. Run same scan logic as above, but for one portal only
4. Display results (same format, just one portal)

---

### `add <company> <url>` — Add Portal

Add a new company portal to the config.

**Steps:**
1. Read `config/portals.json`
2. Determine portal type from URL:
   - Contains `greenhouse.io` → type: `greenhouse`
   - Contains `lever.co` → type: `lever`
   - Contains `ashbyhq.com` → type: `ashby`
   - Otherwise → type: `custom`
3. Add entry to portals array
4. Write updated `config/portals.json`
5. Confirm: "Added {company} ({type}) — {url}. Run `/scan {company}` to scan now."

---

### `history` — Show Scan History

Display scan history from `config/scan_history.json`.

---

### `filters` — Show/Edit Scan Filters

Display current title and location filters.

**Edit:** `/scan filters add-include "AI product manager"` | `/scan filters add-exclude "intern"`

---

## Greenhouse API Parsing

For Greenhouse portals, prefer the JSON API (more reliable than HTML scraping):

```
GET https://boards-api.greenhouse.io/v1/boards/{slug}/jobs
```

Response structure:
```json
{
  "jobs": [
    {
      "id": 12345,
      "title": "Senior Product Manager",
      "location": { "name": "San Francisco, CA" },
      "absolute_url": "https://job-boards.greenhouse.io/{slug}/jobs/12345"
    }
  ]
}
```

Use WebFetch to call this API. Parse the JSON response directly.

## Error Handling

- **WebFetch fails**: Log the portal as "failed", continue with next portal. Report failed portals in summary.
- **No listings found**: Note "0 listings" for that portal. May indicate URL change — suggest checking manually.
- **Rate limiting**: If multiple fetches fail with 429, slow down. Process remaining portals with a brief pause between fetches.
- **Malformed response**: Skip portal, log warning. Don't crash the scan.

## Key Rules

- **Never submit applications.** Scan discovers roles — the user decides what to pursue.
- **Title filtering is strict.** Better to miss a role than pollute the pipeline with noise.
- **Dedup is by URL first, then company+role normalization.** Same role reposted = same entry, not a new one.
- **Scan history is append-only.** Never delete scan history — it's the dedup reference.
- **Greenhouse API is preferred** over HTML scraping where available — more reliable, structured data.
- **Don't scan more than once per day per portal** unless explicitly asked. Check scan_history.json for last scan date.

## Integration with Other Skills

### Feeds Into
- `/eval` — discovered roles need evaluation
- `/pipeline full` — discovered roles appear in top-of-funnel view
- `/battle-plan` — "N roles to evaluate" appears in daily plan

### Receives From
- `/scan add` — user adds new portals to config

### Cross-References in Output
- New roles: "→ /eval {url}" for each discovered role
- Batch: "→ /eval batch" to evaluate all at once
- Always: "→ /save-push" to save results
