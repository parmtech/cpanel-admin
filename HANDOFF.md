# Living Handoff

Project: cPanel Admin (Unofficial)  
Repository: https://github.com/parmtech/cpanel-admin  
Stage: P2 complete for initial Android foundation; P3 next  
Updated: 2026-11-02  
Current milestone: P3 — Tabbed workspace

## Product decisions
- Public third-party project; clearly state unofficial status and do not imply cPanel endorsement.
- Flutter/Dart selected for cross-platform direction; Flutter stable 3.47.5 is pinned.
- Android first; iPhone/iPad planned on the same codebase.
- Direct cPanel UAPI over HTTPS; no credential proxy/backend.
- Multiple labeled profiles; cPanel API tokens stay in Android secure storage.
- The product direction now includes a high-performance tabbed workspace, native UAPI modules, supported cPanel panel browser access, and an optional “ParmTech AI Assistant.”
- A cPanel API token authorizes UAPI calls. It does not itself create a cPanel web login session. cPanel documents WHM API 1 `create_user_session` for temporary SSO; that path needs WHM/reseller capability. See [cPanel SSO docs](https://api.docs.cpanel.net/guides/guide-to-api-authentication/guide-to-api-authentication-single-sign-on/) and [API token docs](https://api.docs.cpanel.net/cpanel/tokens).
- Do not inject cPanel API tokens or OpenAI keys into WebView/page JavaScript. AI uses app-owned allowlisted UAPI tools and requires user approval for writes.
- Feature availability depends on official UAPI support, server/provider configuration, and account permissions. Security and data integrity outrank feature count.

## Current repository state
- README, product spec, roadmap, architecture, security policy, contributor guide, API capability matrix, Android setup, and handoff docs are present.
- Flutter app uses Overview, Files, and Accounts navigation.
- Android files are generated from Flutter template in local setup and CI; generated platform files are not committed.
- Android CI generates the platform, adds INTERNET permission, formats/analyzes `lib/`, builds a debug APK, and uploads it.
- Account profile CRUD and token storage, UAPI connection check, file listing, upload, and UTF-8 text download are implemented.
- Tabbed workspace, authenticated panel WebView, AI assistant, binary download, other service modules, iOS packaging, and signed release build remain unimplemented.
- Local workspace has no Flutter/Dart SDK; GitHub Actions is the build environment.

## Completed
- [x] Confirmed `parmtech/cpanel-admin` is a public repository.
- [x] Added product and security documentation, UAPI capability matrix, contributor guide, and living handoff.
- [x] Added Flutter 3.47.5 Android shell and CI.
- [x] Added multiple cPanel profile CRUD, secure API token storage, connection check, and initial file workflows.
- [x] Added Android network permission bootstrap to local setup and CI.
- [x] Android CI passed format, analysis, debug APK build, and artifact upload for commit `497eb195e6fc440d02c6769817249fa91452bb7e`: https://github.com/parmtech/cpanel-admin/actions/runs/41343115932
- [x] Debug APK artifact: `cpanel-admin-debug`, 162,837,871 bytes, SHA-256 `481d8f026ae1df3d6f01ea1e90c5c640f2aa632a83c08908bd2cfa47894cb8ab`. It is a debug build, not a signed release.
- [x] GitHub issue #1 tracks Flutter foundation.

## Validation and limits
- CI verified Flutter 3.47.5 scaffold generation, package resolution, source formatting, static analysis, APK compilation, and artifact upload.
- No unit/widget tests or live cPanel calls were run in this turn.
- The APK has not been manually installed on a device or emulator.
- Current build only supports UTF-8 text downloads and uploads up to 50 MB.
- AI and browser session features are not implemented.
- “Luna 6 medium” is not assumed to be a supported OpenAI API model ID; model names must be selectable from supported API identifiers.

## Next actions
1. Build tab model and UI (open, close, switch, reorder, move) with every tab bound to a profile ID.
2. Implement native UAPI destinations as tabs for documented features.
3. Choose a valid panel-browser auth flow: cPanel login/session or WHM/reseller SSO; never promise API-token-only web login.
4. Complete file manager UX and validate binary transfer/file mutation endpoints on a disposable account.
5. Add optional OpenAI key/model configuration and an allowlisted assistant action layer with previews and approvals.
6. Continue modules by documented UAPI capabilities, then iOS and signed Android release work.

## Resume instructions for every contributor
1. Pull latest default branch; read this handoff plus product, roadmap, architecture, security, contribution, Android setup, and API matrix docs.
2. Inspect repository and open issues before editing. Repository is the source of truth.
3. Pick the earliest incomplete roadmap task unless the owner reprioritizes.
4. Verify official cPanel UAPI docs for each endpoint; document versions and permissions.
5. Make focused changes; run relevant checks when requested; record exact results.
6. Update this handoff, roadmap, and affected docs with milestone changes.
7. Never claim a feature, build, live server call, or test is complete without code and evidence.

## Change log
- 2026-11-02: Initialized product plan and contributor handoff.
- 2026-11-02: Added and built the first functional Android API/file-management MVP.
- 2026-11-02: Expanded product direction to tabbed cPanel workspace and optional AI assistant.
