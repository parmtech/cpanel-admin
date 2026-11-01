# Security Policy

## Scope
The project is in planning and has no released app versions. Security reports about the current default branch are in scope.

## Reporting
Do not publish tokens, passwords, private hostnames, or exploit details in a public issue. Use GitHub private vulnerability reporting if enabled. If unavailable, open a minimal issue requesting a private reporting channel without exploit details.

## Credential rules
- Never commit API tokens, passwords, session cookies, private keys, or real customer data.
- Use disposable test accounts and synthetic fixtures.
- Redact authorization headers and sensitive response values from logs/crash reports.
- Revoke and rotate any token that may have been exposed.

## Required design controls
- HTTPS only; reject invalid TLS.
- Store tokens only in OS-backed secure storage.
- Exclude credentials from ordinary databases, exports, analytics, and logs.
- Confirm destructive actions; do not blindly retry mutations.
- Validate hosts, URL schemes, ports, and file paths.
- Review dependencies and app permissions.
