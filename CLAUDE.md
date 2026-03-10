# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static landing page for ellijobs.com — Elli's personal brand site showcasing ellipost.com SaaS product. Zero-dependency, no build tools, no frameworks.

## Tech Stack

- **HTML5** — Single `index.html` (+ `404.html`)
- **Vanilla CSS** — `css/styles.css`
- **Vanilla JS** — Inline in HTML (language toggle + year)
- **Hosting** — Cloudflare Pages
- **CI/CD** — GitHub Actions → Wrangler Pages Deploy

## Local Development

```bash
python3 -m http.server 8000
# Open http://localhost:8000
```

No build step, no install, no transpilation.

## Deployment

Push to `main` triggers automatic deploy via `.github/workflows/deploy.yml`.

Required GitHub Secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`.

Manual deploy: `wrangler pages deploy . --project-name=ellijobs`

## Architecture

### Bilingual System (KR/EN)

- Default language: English
- Toggle adds `is-ko` class to `<html>` element
- CSS shows/hides `.lang-ko` / `.lang-en` spans based on `html.is-ko`
- Language preference persisted in `localStorage('lang')`

### CSS Design Tokens

Defined as CSS custom properties in `:root` of `css/styles.css`:
- `--accent: #22d3ee` (cyan) — primary brand color
- `--bg-dark: #0a0a0c` — main background
- `--bg-section: #18181b` — section backgrounds
- `--font-sans: 'Outfit'` — primary typeface (Google Fonts)
- `--max-width: 56rem` — content max width

Responsive breakpoints: `640px` (mobile), `1024px` (desktop).

### Brand Symbol

Inline SVG with gradient (`#7B6CF6` → `#00CEC9`). Used in hero (72x72) and ellipost section (48x48).

### Page Sections

Hero → What I Do (3-card grid) → ellipost Product Card → Vision → CTA → Footer

### Scripts (setup only, not for regular development)

- `scripts/setup-github-secrets.sh` — Configure GitHub Actions secrets
- `scripts/setup-dns.sh` — Cloudflare DNS + Pages domain setup
- `scripts/add-domains.sh` — Add custom domains to Pages
