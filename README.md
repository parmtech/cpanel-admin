# cPanel Admin

Unofficial Flutter companion app for managing cPanel accounts from Android. The app connects directly to each server's cPanel UAPI over HTTPS.

## Working in this build

- Save multiple cPanel profiles with labels, host, port, username, and API token.
- Store API tokens in Android encrypted storage; profile metadata is stored separately.
- Test a profile's API connection and switch between saved accounts.
- Browse directories starting at `public_html`.
- Upload files up to 50 MB and download UTF-8 text files through cPanel UAPI.

## Build

Use Flutter 3.47.5 or newer stable and Android SDK tools:

```sh
flutter create --platforms=android --org au.parmtech --project-name cpanel_admin .
python3 tool/ensure_android_internet.py
flutter pub get
flutter run
```

GitHub Actions builds a debug APK and uploads it as the `cpanel-admin-debug` artifact. Debug APKs are for installation and evaluation; they are not signed release builds.

## Security and scope

Use a dedicated cPanel API token with only the permissions needed. The token stays on device and is sent directly to the configured server over HTTPS. Never commit tokens or server credentials. Self-signed TLS certificates are not accepted.

This is an early Android MVP, not a complete cPanel feature set. Binary file downloads, file deletion/rename, databases, email, domains, backups, server administration, iOS packaging, and release signing remain future work. File downloads in this build are limited to UTF-8 text supported by the cPanel endpoint.
