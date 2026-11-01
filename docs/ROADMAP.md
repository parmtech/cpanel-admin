# A–Z Roadmap

Current phase: P3 — Tabbed workspace design and implementation  
Updated: 2026-11-02

Update this roadmap and HANDOFF.md whenever milestone status changes. Read the product spec, architecture, security policy, contributor guide, and API capability matrix before starting a milestone.

## P0 — Public project foundation
- [x] Public repository and initial product/security/handoff documentation.
- [x] Initial UAPI capability matrix and known gaps.
- [ ] Confirm repository metadata, license choice, and project description.
- [ ] Add issue labels and milestone tracking.

## P1 — Flutter Android shell
- [x] Pin Flutter stable toolchain to 3.47.5.
- [x] Add responsive navigation, theme, accessible labels, and planned-feature states.
- [x] Add CI for Dart formatting, static analysis, Android debug APK, and artifact upload.
- [x] Add Dependabot updates for GitHub Actions and Dart packages.

## P2 — Secure cPanel account foundation
- [x] Add multiple labeled profiles with add/edit/delete/switch flows.
- [x] Store cPanel API tokens in Android secure storage; keep profile metadata separate.
- [x] Add HTTPS UAPI connection check.
- [x] Add Android INTERNET permission bootstrap to local setup and CI.
- [ ] Validate profile isolation and Android lifecycle on emulator and physical device.
- [ ] Add biometric/app lock only after the threat model and recovery path are defined.

## P3 — Tabbed cPanel workspace
- [ ] Define a typed tab model keyed to profile ID, feature route, and optional browser URL.
- [ ] Add new, close, switch, reorder, and move-between-tabs interactions with state restoration.
- [ ] Keep the active account visible and prevent cross-account data leakage.
- [ ] Implement native UAPI tools as app tabs for documented endpoints.
- [ ] Design Panel Browser mode with a supported cPanel session flow.
- [ ] Support token-only native mode without pretending the API token creates a browser login.
- [ ] Decide how users with a cPanel API token but no WHM/reseller access authenticate the panel browser.

Exit: tabs work on phones/tablets, API tabs remain account-scoped, and browser mode only opens with a valid supported session.

## P4 — File Manager
- [x] List files/directories starting at `public_html`.
- [x] Upload files up to 50 MB.
- [x] Download UTF-8 text files.
- [ ] Add breadcrumbs, sorting, refresh polish, search/filter, and file details.
- [ ] Validate binary and large-file download approaches.
- [ ] Add upload progress/cancel.
- [ ] Add create-folder, rename, move/copy/delete only after official UAPI schema validation and confirmation UX.
- [ ] Validate path handling and account isolation on a disposable account.

## P5 — ParmTech AI Assistant
- [ ] Add optional OpenAI API key setup and encrypted local storage.
- [ ] Add model selection from supported API model names; do not assume “Luna 6 medium” is a supported API identifier.
- [ ] Create a documented allowlist of UAPI tools with typed arguments and permission metadata.
- [ ] Send the minimum required context; never send cPanel tokens or secrets to the model.
- [ ] Add action preview, exact target/account display, and user approval before writes.
- [ ] Require explicit confirmation for destructive or hard-to-reverse actions.
- [ ] Treat file, web page, and server content as untrusted; do not follow instructions embedded in returned content.
- [ ] Add cancellation, per-action result, and audit history that excludes secrets.

Exit: assistant can plan and perform approved actions through the same account-scoped UAPI layer; unsupported requests are explained.

## P6 — More cPanel services
Implement as separate capability-aware modules:
- [ ] Domains and DNS.
- [ ] Email accounts and forwarders.
- [ ] Databases.
- [ ] SSL and certificates.
- [ ] Cron jobs.
- [ ] Backups and restores.
- [ ] Metrics, logs, and account usage.

For every module: map official UAPI endpoints, document minimum permissions, handle unsupported/provider-disabled functions, and gate writes behind confirmation. Do not claim all cPanel features where no supported UAPI exists.

## P7 — Android beta readiness
- [ ] Accessibility, screen sizes, orientation, keyboard, and poor-network review.
- [ ] Validate revoked token, invalid TLS, provider restrictions, timeout, and unsupported endpoints.
- [ ] Privacy policy and Android data-safety disclosures.
- [ ] Release signing custody, versioning, and beta rollout plan.
- [ ] Security review and recovery plan.

Exit: Android beta acceptance criteria complete; signed release can be reproduced by maintainers.

## P8 — iPhone and iPad
- [ ] iOS secure-storage and file-picker adapters.
- [ ] iPad split view, keyboard, pointer, multitasking, and rotation.
- [ ] Signing, privacy disclosures, device review, and distribution requirements.

## P9 — Public release and maintenance
- [ ] Version/changelog policy and support matrix.
- [ ] Private vulnerability-reporting path and release-signing custody.
- [ ] Dependency updates, CI monitoring, and issue triage.

## Priority order
1. Credential safety and data integrity.
2. Account setup, isolation, and clear errors.
3. Reliable native UAPI operations.
4. Tabbed navigation and supported panel-session handling.
5. AI actions with explicit user approval.
6. More services and reversible changes.
7. Destructive operations only after endpoint and confirmation review.

Definition of done: implementation, requested validation, UX states, security review, docs, and handoff are updated. A mocked call or successful APK compilation alone does not prove server behavior.
