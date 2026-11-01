# Product Requirements — cPanel Admin

Status: Draft v0.1  
Updated: 2026-11-02  
First platform: Android  
Cross-platform target: iPhone and iPad using Flutter

## Goal
Provide a fast, mobile-first interface for common cPanel account tasks, with multiple named profiles and safe account switching. The app is an API client, not a replacement server implementation. Availability depends on cPanel version, UAPI functions, provider configuration, and account permissions.

## Primary journeys
### Add an account
Open Accounts → Add account. Enter a label, host, username, and API token; port defaults to 2083. Test a low-risk UAPI call over HTTPS. Show a useful result, then save only when the user chooses Save.

### Switch accounts
Unlock if app lock is enabled, select a named profile, and load its dashboard with visible loading, empty, error, and retry states. Every action must identify the active account.

### Manage profiles
Add, test, edit, rename, choose a default, and delete saved profiles. Deleting a profile removes local credentials after confirmation; it never deletes server data.

### Manage files
Browse directories; upload/download; create folders; rename, move, copy, and delete where supported. Show progress and cancellation, handle large files safely, and distinguish server files from local device files.

## Release scope
### Android MVP
- Flutter app shell and Android build.
- Secure account profile lifecycle for multiple accounts.
- Typed UAPI client with HTTPS, timeouts, cancellation, and redacted errors.
- Dashboard identity and basic usage/service information where supported.
- Read-only file listing first; upload/download and safe mutations after that flow is stable.
- Loading, empty, offline, timeout, authentication, permission, and server error states.

### Cross-platform readiness
Keep product and UAPI logic platform independent. Add iOS/iPadOS secure-storage adapters after Android acceptance. Support responsive phone/tablet layouts, keyboard, pointer, rotation, and iPad split view. Do not claim iOS distribution until signing, privacy disclosures, and review requirements are complete.

### Later modules
Domains/DNS; email accounts/forwarders; databases; backups; SSL status; cron jobs; metrics/logs. Each module needs endpoint mapping, capability handling, tests, and risk review.

## Non-goals for MVP
- WHM/reseller/root administration.
- Arbitrary shell commands or privilege escalation.
- Credential proxy or cloud credential sync.
- Claiming parity with every cPanel page.
- Bypassing provider restrictions or account permissions.
- Password scraping or hidden WebView login automation.

An optional cPanel web link for unsupported tasks requires a supported session flow and must never expose API tokens to page JavaScript.

## UX and safety
- Plain-language distinction among host/TLS, invalid token, denied permission, timeout, unsupported endpoint, and server errors.
- Progress and cancellation where supported.
- Confirmation for delete, overwrite, restore, and irreversible operations.
- Accessible contrast, scalable text, screen-reader labels, and touch targets.
- Never show an empty state before initial loading finishes.

## Android MVP acceptance
- At least two profiles work without data mixing.
- API token is held only in platform secure storage and never appears in logs/analytics/diagnostics/exports.
- HTTPS connection test reports useful results without exposing secrets.
- Switching profiles updates screens and discards stale responses.
- Supported UAPI file listing handles loading, empty, permission, and retry states.
- Tests use mocks or disposable accounts; no real credentials are committed.
- Build/release steps and unofficial status are documented.

## Naming
Use “cPanel Admin” as a descriptive working name with “Unofficial” in public materials. Do not use cPanel logos or imply sponsorship. Review trademark and app-store naming requirements before release.
