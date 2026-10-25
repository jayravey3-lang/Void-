# VOID — Backend setup

## What is in this repository
- `index.html`: responsive prototype and animated loading screen.
- `void-logo.svg`: VOID emblem based on the supplied reference artwork.
- `manifest.webmanifest` and `service-worker.js`: install/offline shell.
- `supabase/schema.sql`: database tables and row-level security policies.
- `supabase/functions/search/index.ts`: server-side search endpoint scaffold.
- `supabase/functions/feedback-notify/index.ts`: optional feedback email notification scaffold.

## Connect a real backend
1. Create a Supabase project at https://supabase.com/ and keep its URL and anon key.
2. In Supabase SQL Editor, run `supabase/schema.sql`.
3. In Supabase project settings, configure URL/key for the frontend. Do not commit service-role keys.
4. Deploy Edge Functions with the Supabase CLI. Set any third-party search/email API keys as Edge Function secrets, never in browser JavaScript.
5. Configure the frontend to call the deployed functions and test sign-in, RLS, search, messaging, and feedback with separate test accounts.

## Current status
The UI still runs in local-demo mode until backend configuration is supplied and integration is enabled. No real accounts, cloud syncing, search provider, messaging transport, email delivery, or production deployment is active just from these files. Do not use localStorage as an authentication or security boundary.

## Deploy
GitHub Pages can host the static frontend, but Supabase Edge Functions need to be deployed separately. Enable Pages for this repository and confirm the published base path before testing the manifest and service worker.
