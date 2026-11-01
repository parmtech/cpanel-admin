# Living Handoff

Project: cPanel Admin (Unofficial)  
Repository: https://github.com/parmtech/cpanel-admin  
Stage: Planning / foundation  
Updated: 2026-11-02  
Current milestone: P0 — foundation and API capability mapping

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
- README and initial product, roadmap, architecture, security, contribution, and handoff docs are present.
- App source, CI, endpoint inventory, and release artifacts do not exist yet.

## Completed
- [x] Confirmed parmtech/cpanel-admin is public and writable.
- [x] Initialized product and security documentation.
- [x] Defined milestone sequence and contributor handoff requirement.
- [x] Linked official cPanel UAPI/token references.

## Next actions
1. Confirm repository description, license, and public name/disclaimer.
2. Inventory official UAPI endpoints for identity/health, usage, file list, upload/download, safe file mutations.
3. Select Flutter/Dart toolchain and create Android shell plus CI.
4. Implement secure profile storage and connection test.
5. Build read-only file listing end-to-end before write actions.

## Validation
- Repository metadata and public visibility checked.
- Documentation commits are the only work completed.
- No application code, build, or app tests exist yet.

## Resume instructions for every contributor
1. Pull latest default branch; read this file plus product, roadmap, architecture, security, and contribution docs.
2. Inspect repository and open issues before editing. Repository is the source of truth.
3. Pick the earliest incomplete milestone unless owner reprioritizes.
4. Verify official cPanel UAPI docs for each endpoint; document versions and permissions.
5. Make focused changes and run relevant validation; record exact results.
6. Update this handoff, roadmap, and affected docs before ending. Record commit/PR links, tests, known issues, and next action.
7. Never claim a feature/build/test is complete without code and evidence.

## Change log
- 2026-11-02: Initial product plan and operating handoff added.
