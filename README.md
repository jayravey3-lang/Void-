# VOID — Your Digital Universe

VOID is a responsive, dark-first discovery workspace for exploring ideas, saving useful websites, and keeping personal digital references together.

## Experience
- Atmospheric space-inspired Home and Explore screens.
- Image-led discovery cards, subtle hover effects, and animated ambient background.
- Responsive layout for phones, tablets, and desktop.
- Keyboard shortcut: press `/` to jump to Explore search.
- Motion can be reduced in Settings; system reduced-motion preferences are respected.
- Save curated discoveries and custom websites to a local Library.
- Export local VOID data as JSON and switch between dark and light themes.
- Installable/offline app shell via the web manifest and service worker.

## Run it
Open `index.html` in a browser, or serve the repository through a static web server. For the service worker and installable PWA features, use HTTPS or localhost.

## Backend status
This repository is a local-first prototype. Real sign-in, cloud profile storage, protected feedback, and server-side search require a configured Supabase project and deployed backend functions. Follow [BACKEND_SETUP.md](./BACKEND_SETUP.md). Never place service-role keys or provider secrets in frontend files.

## Project files
- `index.html` — app screens and client-side interactions
- `void-enhancements.css` — premium imagery and motion styling
- `supabase-config.js` — public client configuration placeholder
- `supabase/schema.sql` — database schema and row-level security
- `service-worker.js` and `manifest.webmanifest` — install/offline shell
- `VOID_PRODUCT_BLUEPRINT.md` — product roadmap and boundaries

Images are loaded from Unsplash and require an internet connection; the core app shell remains usable locally.
