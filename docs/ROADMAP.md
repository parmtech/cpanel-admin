# A–Z Roadmap

Current phase: P1 — Flutter Android foundation  
Updated: 2026-11-02

Update this roadmap and HANDOFF.md in the same pull request whenever milestone status changes.

## P0 — Foundation
- [x] Public repository created.
- [x] Product direction, architecture, security, contribution, and handoff docs started.
- [x] Initial official UAPI capability matrix and known gaps documented.
- [ ] Confirm repository metadata, license choice, and project description.
- [ ] Add issue labels and milestone tracking.
Exit: documented scope, security requirements, and first acceptance criteria.

## P1 — Flutter Android shell
- [x] Pin Flutter stable toolchain to 3.47.5.
- [x] Add responsive app shell with navigation, theme, accessible labels, and planned-feature states.
- [x] Add CI for formatting, static analysis, and Android debug APK build.
- [x] Add Dependabot updates for GitHub Actions and Dart packages.
- [x] First CI run passed: https://github.com/parmtech/cpanel-admin/actions/runs/41341758985
- [ ] Add secret-scanning workflow/policy.
- [ ] Add and run test coverage in a separately approved task.
Exit: clean checkout builds reproducibly, CI is green, and foundation acceptance criteria are met.

## P2 — Secure account profiles
- [ ] Profile fields: local ID, label, normalized host, port (2083 default), username, token reference.
- [ ] Add/edit/test/select/default/delete flows.
- [ ] Keep secrets in Android Keystore-backed secure storage; metadata only in ordinary local storage.
- [ ] Consider optional app lock/biometric re-authentication.
Exit: multiple profiles stay isolated; no credential leaks.

## P3 — UAPI client and dashboard
- [ ] Typed transport/client and endpoint registry.
- [ ] HTTPS by default, reject invalid TLS, timeouts, cancellation, redacted errors.
- [ ] Safe retries for idempotent reads only.
- [ ] Map server/API errors to user guidance and detect capabilities.
- [ ] Dashboard uses only validated UAPI data; no disk-usage promise without a supported UAPI function.
Exit: connection test and supported dashboard data work against a disposable account.

## P4 — File manager
- [ ] Read-only Fileman listing, breadcrumbs, sorting, refresh, search/filter.
- [ ] File details.
- [ ] Upload progress/cancel and safe filename handling.
- [ ] Verify supported download/binary behavior before promising general downloads.
- [ ] Create folder, rename, move/copy/delete only after endpoint support and confirmations.
- [ ] Investigate large-file streaming and resumable transfer.
Exit: manual QA on test account; no path traversal or account mix-up.

## P5 — Android beta readiness
- [ ] Accessibility and screen-size review.
- [ ] Test poor network, revoked token, unsupported endpoint, provider restrictions, invalid server TLS.
- [ ] Privacy policy, data safety disclosures, release signing plan.
- [ ] Beta artifact, security review, rollback plan.
Exit: acceptance checklist complete.

## P6 — Additional modules
Domains/DNS; email; databases; backups; SSL; cron; metrics/logs. Deliver each with official endpoint mapping, capability handling, tests, and destructive-action review.

## P7 — iPhone and iPad
- [ ] iOS secure-storage adapter and lifecycle handling.
- [ ] iPad split view, keyboard, pointer, multitasking, rotation.
- [ ] Signing, privacy disclosures, and platform review.
Exit: tested on supported devices/OS versions and distribution requirements met.

## P8 — Public release and maintenance
- [ ] Versioning/changelog policy.
- [ ] cPanel/provider support matrix and known limitations.
- [ ] Private security-reporting path and release-signing custody.
- [ ] Dependency updates and regression triage.

## Priorities
1. Security and data integrity.
2. Stable account setup and clear errors.
3. Common read-only workflows.
4. Upload/download after endpoint validation.
5. Reversible actions.
6. Destructive operations only with safeguards.

Definition of done: implementation, relevant tests when authorized, UX states, security review, docs, and handoff updated. A mocked call alone does not prove an endpoint is supported.
