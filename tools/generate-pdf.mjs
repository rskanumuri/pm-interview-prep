#!/usr/bin/env node

/**
 * generate-pdf.mjs — HTML to PDF via Playwright
 *
 * Usage:
 *   node tools/generate-pdf.mjs <input.html> <output.pdf> [--format=letter|a4]
 *
 * Adapted from career-ops (github.com/santifer/career-ops).
 * Uses Chromium headless to render ATS-optimized resume PDFs.
 *
 * Notes (Oct 2026 fixes):
 *  - Loads the HTML via a real file:// URL (page.goto) instead of setContent, which has no
 *    baseURL option, so local fonts were blocked and silently fell back to system fonts.
 *  - Builds file URLs with pathToFileURL (file:///C:/... on Windows, not file://C:/...).
 *  - Always closes the browser, even on error. Creates the output directory if missing.
 *  - Warns when the requested fonts did not load instead of failing silently.
 */

import { chromium } from 'playwright';
import { resolve, dirname } from 'path';
import { readFile, writeFile, mkdir, unlink } from 'fs/promises';
import { fileURLToPath, pathToFileURL } from 'url';

const __dirname = dirname(fileURLToPath(import.meta.url));

async function generatePDF() {
  const args = process.argv.slice(2);

  let inputPath, outputPath, format = 'letter';

  for (const arg of args) {
    if (arg.startsWith('--format=')) {
      format = arg.split('=')[1].toLowerCase();
    } else if (!inputPath) {
      inputPath = arg;
    } else if (!outputPath) {
      outputPath = arg;
    }
  }

  if (!inputPath || !outputPath) {
    console.error('Usage: node generate-pdf.mjs <input.html> <output.pdf> [--format=letter|a4]');
    process.exit(1);
  }

  inputPath = resolve(inputPath);
  outputPath = resolve(outputPath);

  const validFormats = ['a4', 'letter'];
  if (!validFormats.includes(format)) {
    console.error(`Invalid format "${format}". Use: ${validFormats.join(', ')}`);
    process.exit(1);
  }

  console.log(`Input:  ${inputPath}`);
  console.log(`Output: ${outputPath}`);
  console.log(`Format: ${format.toUpperCase()}`);

  await mkdir(dirname(outputPath), { recursive: true });

  // Resolve relative font paths to absolute file:// URLs for Chromium
  let html = await readFile(inputPath, 'utf-8');
  const fontsUrl = pathToFileURL(resolve(__dirname, 'fonts')).href; // file:///C:/.../fonts
  html = html.replace(/url\((['"]?)\.\/fonts\//g, (_m, q) => `url(${q || "'"}${fontsUrl}/`);

  // Render from a temp file next to the input so Chromium treats it as a file:// page
  // (page.setContent has no baseURL option and loads from about:blank, which blocks file:// fonts).
  const tmpHtml = resolve(dirname(inputPath), `.__render_${process.pid}.html`);
  await writeFile(tmpHtml, html, 'utf-8');

  let browser;
  try {
    browser = await chromium.launch({ headless: true });
    const page = await browser.newPage();
    await page.goto(pathToFileURL(tmpHtml).href, { waitUntil: 'networkidle' });

    // Wait for fonts to load, then report any declared font that did not
    await page.evaluate(() => document.fonts.ready);
    const failed = await page.evaluate(() =>
      [...document.fonts].filter((f) => f.status === 'error').map((f) => f.family)
    );
    if (failed.length) {
      console.warn(`WARNING: fonts failed to load, fell back to system fonts: ${[...new Set(failed)].join(', ')}`);
    }

    const pdfBuffer = await page.pdf({
      format: format,
      printBackground: true,
      margin: {
        top: '0.6in',
        right: '0.6in',
        bottom: '0.6in',
        left: '0.6in',
      },
      preferCSSPageSize: false,
    });

    await writeFile(outputPath, pdfBuffer);

    // Page count: prefer the /Count of the page tree; fall back to counting page objects.
    // Both are approximate when Chromium compresses object streams, so report accordingly.
    const pdfString = pdfBuffer.toString('latin1');
    const counts = [...pdfString.matchAll(/\/Type\s*\/Pages[^>]*?\/Count\s+(\d+)/g)].map((m) => Number(m[1]));
    const pageCount = counts.length
      ? Math.max(...counts)
      : (pdfString.match(/\/Type\s*\/Page[^s]/g) || []).length;

    console.log(`PDF generated: ${outputPath}`);
    console.log(`Pages: ${pageCount} (approximate)`);
    console.log(`Size: ${(pdfBuffer.length / 1024).toFixed(1)} KB`);

    // Output JSON for Claude Code to parse
    console.log(JSON.stringify({ status: 'success', outputPath, pageCount, size: pdfBuffer.length, fontsFailed: failed }));

    return { outputPath, pageCount, size: pdfBuffer.length };
  } finally {
    if (browser) await browser.close();
    await unlink(tmpHtml).catch(() => {});
  }
}

generatePDF().catch((err) => {
  console.error('PDF generation failed:', err.message);
  console.log(JSON.stringify({ status: 'failed', error: err.message }));
  process.exit(1);
});
