# Living Handoff

Project: cPanel Admin (Unofficial)  
Repository: https://github.com/parmtech/cpanel-admin  
Stage: Planning / foundation  
Updated: 2026-11-02  
Current milestone: P1 preparation — Android foundation

## Product decisions
- Public third-party project; clearly state unofficial status and do not imply cPanel endorsement.
- Flutter/Dart selected for cross-platform direction.
- Android first; iPhone/iPad planned on the same codebase.
- Direct cPanel UAPI over HTTPS in MVP; no credential proxy/backend.
- Multiple labeled profiles; each token in OS secure storage.
- Feature availability depends on official UAPI support, server/provider configuration, and account permissions.
- Native dashboard and common workflows; unsupported operations may link to cPanel only through a supported session flow.
- Security and data integrity outrank feature count.

## Current repository state
- README, product spec, roadmap, architecture, security policy, contributor guide, living handoff, and initial API capability matrix are present.
- API matrix is documentation research only. No endpoint has been live-tested against a cPanel server.
- App source, CI, and release artifacts do not exist yet.

## Completed
- [x] Confirmed parmtech/cpanel-admin is public and writable.
- [x] Initialized product and security documentation.
- [x] Defined milestone sequence and contributor handoff requirement.
- [x] Researched initial official UAPI candidates for identity, Fileman, upload, domains, and disk usage.
- [x] Recorded that cPanel documents no UAPI equivalent for legacy API 2 DiskUsage fetchdiskusage; do not silently add deprecated API 2 to the MVP dashboard.
- [x] Recorded that generic binary download behavior still needs validation.

## Next actions
1. Confirm repository description, license, and public name/disclaimer.
2. Select Flutter/Dart versions supported by current Android tooling and pin them.
3. Create app shell, navigation, accessibility/theme baseline, and Android CI.
4. Implement secure profile storage and connection test.
5. Confirm UAPI schemas against exact target cPanel versions; use a disposable test account before integrating any live feature.
6. Implement read-only Fileman listing, then separately validate upload and binary download.

## Validation
- Repository metadata and public visibility checked.
- Documentation commits are the only implementation completed.
- No application code, build, or app tests exist yet.
- API research is based on official cPanel docs linked from docs/API_CAPABILITY_MATRIX.md, not live server behavior.

## Resume instructions for every contributor
1. Pull latest default branch; read this file plus product, roadmap, architecture, security, contribution, and API matrix docs.
2. Inspect repository and open issues before editing. Repository is the source of truth.
3. Pick the earliest incomplete milestone unless owner reprioritizes.
4. Verify official cPanel UAPI docs for each endpoint; document versions and permissions.
5. Make focused changes and run relevant validation; record exact results.
6. Update this handoff, roadmap, and affected docs before ending. Record commit/PR links, tests, known issues, and next action.
7. Never claim a feature/build/test is complete without code and evidence.

## Change log
- 2026-11-02: Initial product plan and operating handoff added.
- 2026-11-02: Added UAPI capability matrix and documented disk-usage/download limitations.
