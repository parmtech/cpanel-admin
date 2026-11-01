# cPanel Admin (Unofficial)

A secure, cross-platform mobile companion for managing cPanel accounts. Android is the first target; iPhone and iPad are planned on the same Flutter codebase.

> Unofficial project: not affiliated with, endorsed by, or supported by cPanel, L.L.C. cPanel is a trademark of its respective owner.

## Product direction
Manage multiple cPanel accounts from one app. Save each profile with a user-chosen label, server host, username, and API token. Select an account and use a native dashboard and tools for operations available through cPanel UAPI and permitted by the account.

The app cannot promise every cPanel screen or hosting-provider feature is available through the API. Unsupported operations should be identified clearly and may link to the cPanel interface.

## Planned capabilities
- Account profiles: add, test, rename, edit, select, and remove multiple accounts.
- Dashboard: account identity, usage, service status, and shortcuts.
- File manager: browse, upload, download, create folders, rename, move, copy, and delete where supported.
- Later modules: domains, email, databases, backups, SSL, cron, and metrics.
- Security: OS-backed credential storage, destructive-action confirmations, redacted diagnostics, and no secrets in source control.

## Project documents
- [Product requirements](docs/PRODUCT_SPEC.md)
- [Roadmap](docs/ROADMAP.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Security policy](SECURITY.md)
- [Contributor guide](CONTRIBUTING.md)
- [Living handoff](HANDOFF.md)

## Status
Planning / foundation stage. No app implementation or release build is claimed yet. Read HANDOFF.md before starting work.

Use only accounts and API tokens you are authorized to manage. Prefer a dedicated token and revoke it if exposed. Never place credentials in issues, pull requests, screenshots, fixtures, or logs.

## References
- [cPanel UAPI documentation](https://api.docs.cpanel.net/)
- [API Tokens in cPanel](https://api.docs.cpanel.net/cpanel/tokens)
- [Manage API Tokens interface](https://docs.cpanel.net/cpanel/security/manage-api-tokens/)
