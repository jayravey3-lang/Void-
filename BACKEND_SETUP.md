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

## Frontend auth wiring
- Fill in `supabase-config.js` with the project's Supabase URL and anon/public key.
- Auth UI supports email/password sign-in and sign-up. Email confirmation depends on your Supabase Auth settings.
- The profile editor and feedback form can write to the Supabase tables after the schema is applied.
- Keep the Supabase service-role key and Resend key only in Edge Function secrets.
- The prototype's saved-library and demo-conversation UI are still local-first; cloud bookmark sync and recipient discovery are not yet wired into the UI.

## Additional privacy and moderation migration
After reviewing the statements in `supabase/migrations/20261025_void_security_social.sql`, run it after `supabase/schema.sql`. It adds username/profile-visibility fields, a user-block list, and a private report table. Test the resulting row-level-security behavior with at least two separate test accounts before using real user data.

**Important:** The migration deliberately does not make production messaging safe by itself. A trusted server-side send-message operation must enforce blocks for both participants before messaging is enabled. The current browser messaging screen is a local demo.

## Current feature boundaries
- Custom website bookmarks, library filtering, appearance choice, and JSON export are device-local features.
- The Supabase client is loaded from a CDN. A network connection is required for account features.
- Real search requires a compatible provider configured as Edge Function secrets.
- Feedback email notifications require a verified sender, provider secrets, and a trusted server-side invocation. Do not expose a notification secret in the browser.
- GitHub Pages deployment must be enabled and tested in repository settings; a workflow file alone does not prove the site is published.
