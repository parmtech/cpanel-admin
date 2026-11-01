# Living Handoff

Project: cPanel Admin (Unofficial)  
Repository: https://github.com/parmtech/cpanel-admin  
Stage: P1 — Flutter Android foundation  
Updated: 2026-11-02  
Current milestone: P1 — finish security scan policy and prep P2

## Product decisions
- Public third-party project; clearly state unofficial status and do not imply cPanel endorsement.
- Flutter/Dart selected for cross-platform direction; Flutter stable 3.47.5 is pinned.
- Android first; iPhone/iPad planned on the same codebase.
- Direct cPanel UAPI over HTTPS in MVP; no credential proxy/backend.
- Multiple labeled profiles; each token in OS secure storage.
- Feature availability depends on official UAPI support, server/provider configuration, and account permissions.
- Native dashboard and common workflows; unsupported operations may link to cPanel only through a supported session flow.
- Security and data integrity outrank feature count.

## Current repository state
- README, product spec, roadmap, architecture, security policy, contributor guide, API capability matrix, and Android setup guide are present.
- Flutter source app shell is in lib/main.dart. It has Overview, Tools, and Settings navigation with clearly marked planned capabilities.
- Android platform files are generated from the pinned Flutter template in local setup and CI; generated platform files are not committed.
- Android CI formats and analyzes lib/, builds a debug APK, and uploads the artifact.
- Dependabot is configured for GitHub Actions and Pub.
- Account profile storage, cPanel networking, and server operations are not implemented.
- No tests were added or run in this turn.

## Completed
- [x] Confirmed parmtech/cpanel-admin is public and writable.
- [x] Initialized product and security documentation.
- [x] Added UAPI candidate matrix and recorded API limitations.
- [x] Added Flutter 3.47.5 app shell, Android setup guide, CI, and dependency updates.
- [x] Fixed analyzer failure caused by Flutter's generated sample test file; analyze only committed app source until test setup is added.
- [x] Android CI passed formatting, analyzer, debug APK build, and artifact upload: https://github.com/parmtech/cpanel-admin/actions/runs/41341758985
- [x] Debug APK artifact: cpanel-admin-debug, 69,902,306 bytes, SHA-256 da647929dd494d8fb1e68c1e188ce12777e80ae8e9724c9c874856ed8c48dd1b.
- [x] Issue #1 tracks the remaining P1 foundation work: https://github.com/parmtech/cpanel-admin/issues/1

## Validation
- Local workspace has Java 17 but no Flutter or Dart SDK.
- GitHub Actions verified Flutter 3.47.5, Android project generation, dependency resolution, Dart formatting, source analysis, Android debug APK build, and artifact upload.
- No unit/widget tests were added or run.
- The debug APK is a development artifact, not a signed release build.

## Next actions
1. Add a secret-scanning policy/check that is suitable for a public repository.
2. Decide/add a project license, repository description, issue labels, and milestones.
3. Proceed to secure account profiles: local model and CRUD UI; keep secrets in Android Keystore-backed storage.
4. Then add a UAPI connection test using an explicitly configured disposable account, never a production credential by default.
5. Later, validate exact UAPI schemas and file-transfer behavior.

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
- 2026-11-02: Added Flutter foundation; CI initially exposed a generated-template test mismatch, then passed after source-scoped analysis.
