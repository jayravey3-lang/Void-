# VOID — Master Product Blueprint

**Product promise:** Your Digital Universe. A personal, privacy-aware workspace for discovery, saved knowledge, communication, and focused work.

This document combines the requirements gathered during VOID planning. It is a product plan, not a claim that all features are already implemented.

## 1. Brand and experience
- Name: VOID.
- Brand mark: metallic silver V with glowing blue orbital rings, based on the supplied reference artwork.
- Visual system: deep navy/near-black base, electric blue and cyan highlights, restrained purple gradients, crisp typography, subtle glow.
- Motion: branded loading screen, animated progress indicator, reduced-motion support, no unnecessary animations.
- Responsive from small mobile screens through desktop.
- Accessible keyboard navigation, labels, focus states, readable contrast, and meaningful empty/error/loading states.
- Keep the primary interface clean. Avoid feeds for trending sites or popular searches.

## 2. Main navigation
- Home: personalized dashboard and launchpad.
- Explore: discovery and search.
- Library: bookmarks and saved knowledge.
- Connect: messaging and social features.
- My VOID: account and profile.
- Settings: appearance, privacy, notifications, security and data.
- Feedback: suggestions and bug reports.

## 3. Home dashboard
- Greeting, date/time and quick actions.
- Favorite shortcuts, recent items and saved items.
- Unread-message count and notification summary.
- Optional weather and other widgets only after reliable providers are selected.
- Widget visibility, ordering, resizing and layout preferences.
- Calm default design; optional stronger visual effects.

## 4. Explore and universal search
- Search the web using a configured provider; do not imply that sample data is live web search.
- Search saved Library items and, when enabled, the user's own content.
- Category filters and suggestions.
- Result previews, clear source labels, and actions to save or open a result.
- Open websites in a separate browser tab when embedding is blocked or unsafe.
- Rate limits, input validation, error handling, and server-side provider secrets.
- No trending/popular-search feed by default.

## 5. Library
- Add a website by title and HTTP/HTTPS URL.
- Save a discovery, edit metadata, categorize, filter, search, remove, and open saved links.
- Cloud sync across authenticated devices once backend is configured.
- Export user data; provide an import flow with schema validation before adding it.
- Local-only mode must be clearly labelled and must never be represented as cloud backup.

## 6. Accounts and profiles
- Email/password registration and login, email confirmation, logout and session recovery.
- Unique username separate from display name; bio and optional avatar.
- Explicit public/private profile setting.
- Optional two-factor authentication and stronger confirmation for sensitive account actions.
- Account deletion and data export with clear confirmation and honest explanation of what is deleted.
- Never store passwords in app tables or local storage.
- Use only public/anon client credentials in frontend. Never expose service-role keys or email-provider secrets.

## 7. Connect messaging
- Contact discovery and message requests with block/report controls.
- One-to-one conversations, real-time delivery, timestamps and read receipts.
- Edit/delete with visible state indicators; pin, mute, archive and search conversations.
- Typing indicators and optional presence controls.
- Voice notes and private media/file uploads.
- Group chats with membership roles and administrator permissions.
- Voice/video calling is a later phase, requiring a dedicated signaling/media design.
- Messages are only visible to authorized participants; apply database policies and server-side validation.
- Product requirement currently prefers secure transport and server-side storage, not end-to-end encryption. Revisit this explicitly before launch.

## 8. Settings and notifications
- Dark theme by default, optional light theme, device-following option later.
- Static/animated background preferences and subtle effects.
- Notification preferences, quiet hours and privacy-preserving previews.
- Keep important security notifications enabled.
- Privacy settings, blocked users, sessions, data export and deletion controls.

## 9. Feedback and moderation
- Feedback form: Category (Suggestion by default), Subject, Details.
- Persist feedback in a protected database table.
- Private admin dashboard with status workflow: new, in review, resolved, closed.
- Email notification recipient planned: voidsearch0@gmail.com.
- Email requires a verified sender/domain and server-side provider secrets.
- Reports and appeals need restricted moderator access, audit trails and fair review.
- Do not place private feedback data in a public client bundle or expose an unrestricted read endpoint.

## 10. Architecture
- Current front end: static HTML/CSS/JavaScript prototype in index.html.
- Hosting candidate: GitHub Pages for the static site.
- Backend candidate: Supabase Auth, Postgres with row-level security, Storage and Edge Functions.
- Search provider and email delivery provider remain configuration choices.
- Secrets belong in backend environment secrets, never browser JavaScript or Git.
- Keep database migrations versioned and test RLS with separate users.
- Add automated tests and CI checks before production.

## 11. Data and security requirements
- Enforce least privilege and ownership checks in database policies.
- Validate all inputs on both client and server.
- Escape user-generated content before rendering.
- Limit request sizes and rate-limit authentication, search, messaging and feedback.
- Private files must use protected storage policies and signed URLs when appropriate.
- Avoid logging message bodies, passwords, tokens or sensitive feedback.
- Plan abuse reporting, blocking, moderation, backups, retention and incident response.
- Local storage is convenience storage only, never an authentication/security boundary.

## 12. Current repository snapshot
- index.html: responsive interface, loading screen, sample discovery, local demo messaging/profile/feedback, Supabase account integration hooks, and recently added custom website bookmarks, library filtering, theme choice and JSON export.
- void-logo.svg and void-icon.svg: vector brand assets.
- manifest.webmanifest and service-worker.js: install/offline shell.
- supabase-config.js: public configuration template with placeholders.
- supabase/schema.sql: initial tables and RLS policies.
- supabase/functions/search/index.ts: provider-backed search scaffold.
- supabase/functions/feedback-notify/index.ts: email notification scaffold.
- .github/workflows/deploy-pages.yml: GitHub Pages deployment workflow.
- BACKEND_SETUP.md: backend and deployment instructions.
- README.md: preserve the existing file unless the owner explicitly asks to change it.

## 13. Delivery roadmap
### Phase 1 — Frontend MVP
- Finish accessible navigation, responsive layout and branded loading experience.
- Complete local bookmarks, search/filter, profile preferences, data export/import.
- Add robust validation, empty/loading/error states and browser testing.

### Phase 2 — Backend foundation
- Create Supabase project and configure public URL/key.
- Apply reviewed migrations, tighten profile visibility and messaging policies.
- Test registration, confirmation, login, logout and session handling with test accounts.
- Deploy and test functions with provider secrets held server-side.

### Phase 3 — Cloud personal data
- Sync profiles and bookmarks.
- Build private feedback submission and administrator-only dashboard.
- Configure verified email delivery to voidsearch0@gmail.com and test delivery.

### Phase 4 — Search and Connect
- Choose a search provider and implement real search.
- Add contacts, requests, conversations, messaging and real-time updates.
- Add blocking, reporting, moderation and group permission checks.
- Add private uploads and voice notes after core messaging is secure.

### Phase 5 — Polish and release
- Add widget customization, notification controls, optional two-factor authentication and account lifecycle flows.
- Configure GitHub Pages base paths and service-worker caching safely.
- Run accessibility, mobile/desktop, security-policy and regression tests.
- Publish only after the live deployment and real backend have been verified.

## 14. Definition of done
A feature is not "live" merely because a UI or schema exists. It is complete only after its provider is configured, permissions are tested, success/error paths are exercised, and the deployed experience has been verified.
