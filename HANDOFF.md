# Living Handoff

Project: cPanel Admin (Unofficial)  
Repository: https://github.com/parmtech/cpanel-admin  
Stage: P1 — Flutter Android foundation  
Updated: 2026-11-02  
Current milestone: P1 — verify Android scaffold and CI

## Product decisions
- Public third-party project; clearly state unofficial status and do not imply cPanel endorsement.
- Flutter/Dart selected for cross-platform direction; Flutter stable 3.47.5 is pinned for the foundation.
- Android first; iPhone/iPad planned on the same codebase.
- Direct cPanel UAPI over HTTPS in MVP; no credential proxy/backend.
- Multiple labeled profiles; each token in OS secure storage.
- Feature availability depends on official UAPI support, server/provider configuration, and account permissions.
- Native dashboard and common workflows; unsupported operations may link to cPanel only through a supported session flow.
- Security and data integrity outrank feature count.

## Current repository state
- README, product spec, roadmap, architecture, security policy, contributor guide, API capability matrix, and Android setup guide are present.
- Flutter source app shell is under lib/main.dart.
- Android platform directory is generated from the pinned Flutter template by the documented command and CI; generated platform files are not committed.
- Android CI workflow runs formatting, static analysis, and a debug APK build; the first run has not been observed yet.
- Dependabot is configured for GitHub Actions and Pub dependencies.
- Account profile storage, cPanel networking, and server operations are not implemented.
- No tests have been added or run in this turn.

## Completed
- [x] Confirmed parmtech/cpanel-admin is public and writable.
- [x] Initialized product, security, and contributor documentation.
- [x] Researched initial official UAPI candidates and documented gaps.
- [x] Added Flutter 3.47.5 app shell, Android setup guide, CI workflow, and dependency update config.
- [x] Added issue #1 for foundation follow-through: https://github.com/parmtech/cpanel-admin/issues/1

## Validation
- Confirmed this workspace has Java 17 but does not have Flutter or Dart installed.
- Did not run format, analyzer, build, or tests locally.
- GitHub Actions API currently showed no workflow runs for this repository; CI outcome is unverified.
- Source changes are committed to main at bcdd828164586040cdbd54baa9b9cd2e1cc17e2c.

## Next actions
1. Observe the first Android foundation workflow run and fix formatting/analyzer/build failures.
2. Add a secret-scanning check and update the P1 completion status.
3. Decide repository license and add issue labels/milestones.
4. Proceed to secure account profiles only after the P1 build is green.
5. Later, validate exact UAPI schemas and file-transfer behavior against a disposable cPanel account.

## Resume instructions for every contributor
1. Pull latest default branch; read this file plus product, roadmap, architecture, security, contribution, Android setup, and API matrix docs.
2. Inspect repository and open issues before editing. Repository is the source of truth.
3. Pick the earliest incomplete milestone unless owner reprioritizes.
4. Verify official cPanel UAPI docs for each endpoint; document versions and permissions.
5. Make focused changes and run relevant validation only when requested; record exact results.
6. Update this handoff, roadmap, and affected docs before ending. Record commit/PR links, tests/validation, known issues, and next action.
7. Never claim a feature/build/test is complete without code and evidence.

## Change log
- 2026-11-02: Initial product plan and operating handoff added.
- 2026-11-02: Added Flutter app shell and Android CI scaffold; local build unavailable in this workspace.
