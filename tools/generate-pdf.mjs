#!/usr/bin/env node

/**
 * generate-pdf.mjs — HTML to PDF via Playwright
 *
 * Usage:
 *   node tools/generate-pdf.mjs <input.html> <output.pdf> [--format=letter|a4]
 *
 * Uses Chromium headless to render ATS-optimized resume PDFs.
 */

import { chromium } from 'playwright';
import { resolve, dirname } from 'path';
import { readFile, writeFile } from 'fs/promises';
import { fileURLToPath } from 'url';

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

  // Read HTML and resolve font paths to absolute file:// URLs
  let html = await readFile(inputPath, 'utf-8');

  const fontsDir = resolve(__dirname, 'fonts');
  // Convert relative font paths to absolute file:// URLs for Chromium
  html = html.replace(
    /url\(['"]?\.\/fonts\//g,
    `url('file://${fontsDir.replace(/\\/g, '/')}/`
  );
  html = html.replace(
    /file:\/\/([^'")]+)\.woff2['"]\)/g,
    `file://$1.woff2')`
  );

  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  await page.setContent(html, {
    waitUntil: 'networkidle',
    baseURL: `file://${dirname(inputPath).replace(/\\/g, '/')}/`,
  });

  // Wait for fonts to load
  await page.evaluate(() => document.fonts.ready);

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

  // Approximate page count from PDF structure
  const pdfString = pdfBuffer.toString('latin1');
  const pageCount = (pdfString.match(/\/Type\s*\/Page[^s]/g) || []).length;

  await browser.close();

  console.log(`PDF generated: ${outputPath}`);
  console.log(`Pages: ${pageCount}`);
  console.log(`Size: ${(pdfBuffer.length / 1024).toFixed(1)} KB`);

  // Output JSON for Claude Code to parse
  console.log(JSON.stringify({ status: 'success', outputPath, pageCount, size: pdfBuffer.length }));

  return { outputPath, pageCount, size: pdfBuffer.length };
}

generatePDF().catch((err) => {
  console.error('PDF generation failed:', err.message);
  console.log(JSON.stringify({ status: 'failed', error: err.message }));
  process.exit(1);
});
