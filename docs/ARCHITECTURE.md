# Architecture

Status: Proposed for MVP  
Updated: 2026-11-02

## Platform
- Flutter/Dart; Android first, iOS/iPadOS planned.
- Native plugins only behind interfaces for secure storage, biometrics, file picker, and downloads.
- No app-owned credential proxy/backend in MVP.
- Keep dependencies minimal and pinned.

## Layers
1. Presentation: account picker, dashboard, feature screens, loading/error/empty states.
2. Application: use cases such as TestAccount, LoadUsage, ListFiles, UploadFile.
3. Domain: profile metadata, capabilities, typed results, validation.
4. Infrastructure: UAPI transport, secure secret store, metadata store, platform file adapters.

Screens must not construct API URLs or handle tokens directly. Each request uses an account-scoped client so switching profiles cannot reuse another account's credentials.

## Profile and secret separation
Metadata may include stable local ID, label, normalized host/port, username, capability metadata, and last connection time. Store the API token separately in OS-backed secure storage, referenced by profile ID. Never put secrets in preferences, ordinary databases, exports, logs, analytics, clipboard, or screenshots. Deleting a profile removes its token.

## UAPI client
Use cPanel UAPI over HTTPS on port 2083 by default and the documented token Authorization format. Encode parameters with the HTTP library; do not concatenate untrusted path/query strings.

Responsibilities:
- HTTPS only; reject invalid certificates; no ignore-TLS option.
- Connect/read timeouts and cancellation.
- Separate transport errors from UAPI application errors.
- Redact authorization headers, secret parameters, and sensitive response fields.
- Typed endpoint wrappers and capability registry.
- Retry idempotent reads only; never blindly retry mutations.
- Discard stale responses after account switching.

## Capability model
Show a feature only when its UAPI endpoint exists on the target server and permissions/provider settings allow it. Maintain an endpoint inventory containing function, method, parameters, verified cPanel version, permissions, risk class, and tests. Explain unavailable features clearly.

## File transfers
Use supported UAPI Fileman operations. Normalize path segments and scope to the active account. Stream large transfers. Show target, filename, size, progress, and cancellation. Confirm overwrite/delete. Use platform document pickers for downloads. Do not follow links outside the intended account root without explicit safe behavior.

## Local data/lifecycle
- Clear in-memory token material when app locks/backgrounds where practical.
- Version local metadata migrations.
- No cloud sync in MVP. Any future sync needs a threat model and end-to-end encryption design.
- Exports omit credentials by default and warn about server configuration.

## Tests
- Unit: host validation, response parsing, error mapping, path handling, redaction, capability decisions.
- Contract: fixtures derived from documented UAPI response shapes.
- Integration: opt-in disposable test account; never hit production by default.
- UI: profile CRUD, account switching, loading/error states, file manager.
