# Product Requirements — cPanel Admin

Status: Draft v0.2  
Updated: 2026-11-02  
First platform: Android  
Cross-platform target: iPhone and iPad using Flutter

## Goal
Build a fast, Android-first cPanel control centre with multiple named accounts, a tabbed workspace, native UAPI tools, and an optional AI assistant. Keep the interface responsive and make the maximum cPanel capabilities available when the server exposes supported APIs and the account has permission.

The app has two access modes:
- **Native API mode:** cPanel account API token calls UAPI directly over HTTPS. Native tools are fast and can show clear progress, errors, and confirmations.
- **Panel browser mode:** show the cPanel web UI in an embedded browser only after obtaining a supported cPanel web session. A cPanel account API token authenticates UAPI calls; it does not by itself create a cPanel web login session. WHM API 1 `create_user_session` requires WHM/reseller access. Otherwise the user must complete the supported cPanel login flow. See [cPanel SSO documentation](https://api.docs.cpanel.net/guides/guide-to-api-authentication/guide-to-api-authentication-single-sign-on/) and [API token documentation](https://api.docs.cpanel.net/cpanel/tokens).

Do not claim full cPanel UI access from only host, username, and cPanel API token. The panel browser must not receive or inject API tokens into page JavaScript.

## Primary journeys

### Add and manage accounts
Open Accounts → Add account. Enter a label, host, port (2083 by default), username, and cPanel API token. Test a low-risk UAPI request over HTTPS. Save, switch, edit, rename, set default, or delete local profiles. Keep tokens in OS secure storage and metadata separately. Deleting an app profile never deletes server data.

### Work in tabs
A tab belongs to a saved cPanel profile and opens a supported native tool or an authenticated panel page. Users can open, close, switch, reorder, and move between tabs without losing the current account context. Examples include a domain tab, File Manager tab, and database tab. Show the active account and service in every tab. Discard stale responses when switching profiles.

### Manage files
Browse directories and supported file types; upload and download with progress; create folders, rename, move, copy, and delete only where official endpoints support them. Protect against path traversal, overwrite accidents, and account mix-ups. Handle large files safely and report unsupported binary download behavior clearly.

### Use ParmTech AI Assistant
AI is optional. The user may add an OpenAI API key in Settings and choose an API-supported model. Store the key in OS secure storage. With no key configured, all non-AI app features remain usable.

The assistant accepts plain-language requests and maps them only to documented, allowlisted cPanel UAPI actions for the selected profile. Show the target account, action, and affected items. Require user approval before any write; require an explicit confirmation for destructive or difficult-to-reverse operations. Never execute arbitrary shell commands or model-generated URLs. Do not send cPanel API tokens or OpenAI keys to the model. Treat website and server-returned text as untrusted input. Make the model choice configurable; do not hardcode an unsupported model alias.

## Current Android build
The current debug APK includes:
- Multiple labeled cPanel account profiles, with add/edit/delete/switch flows.
- Android encrypted storage for cPanel API tokens.
- HTTPS UAPI connection test.
- File listing starting at `public_html`.
- Uploads up to 50 MB and UTF-8 text downloads.

This build does not yet include the tabbed workspace, authenticated cPanel WebView, AI assistant, binary downloads, other cPanel modules, iOS packaging, or release signing. File downloads are limited to UTF-8 text supported by the cPanel endpoint.

## Future cPanel modules
Domains/DNS; email accounts/forwarders; databases; backups; SSL; cron jobs; metrics/logs; account usage. Every module needs endpoint mapping, capability detection, permission handling, and clear unsupported states. Use UAPI where available; do not invent API2 substitutes where cPanel has no supported UAPI equivalent.

## Safety and UX requirements
- HTTPS by default; reject invalid TLS certificates and never offer a silent insecure bypass.
- Explain host/TLS, invalid-token, permission, timeout, unsupported-function, and server errors in plain language.
- Confirm deletion, overwrite, restore, and irreversible actions.
- AI actions must show the concrete account and change before approval.
- Keep credentials out of logs, analytics, crash reports, exported files, and model prompts.
- Accessible contrast, scalable text, screen-reader labels, keyboard/pointer support, and usable touch targets.
- Show loading state before empty state.

## Cross-platform readiness
Keep product and UAPI logic platform independent. Add iOS/iPadOS secure-storage and file adapters after Android acceptance. Support phone/tablet layouts, rotation, keyboard, pointer, and iPad split view. Do not claim iOS distribution until signing, privacy disclosures, and review requirements are complete.

## Non-goals
- WHM/root administration unless separately designed and explicitly permissioned.
- Arbitrary shell commands, privilege escalation, credential proxy, or cloud credential sync.
- Claiming parity with every cPanel page or bypassing server/provider restrictions.
- Password scraping, hidden WebView login automation, or passing API tokens to web content.

## Naming
Use “cPanel Admin” as a descriptive working name with “Unofficial” in public materials. The optional assistant's working name is “ParmTech AI Assistant.” Do not use cPanel logos or imply sponsorship. Review trademark and app-store naming requirements before release.
