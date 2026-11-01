# Android Development Setup

This repository stores the Flutter app source and generates the Android platform scaffold from the pinned Flutter SDK. This keeps the generated Gradle wrapper and platform boilerplate aligned with Flutter's own project template.

## Toolchain
- Flutter 3.47.5 stable (also pinned in GitHub Actions).
- Android SDK/command-line tools and a compatible Java runtime.
- Android device or emulator for manual UI checks.

## First local setup
From the repository root:

1. Install Flutter 3.47.5 stable and Android tooling using the official Flutter instructions.
2. Generate the Android platform files:
   flutter create --platforms=android --org au.parmtech --project-name cpanel_admin .
3. Resolve packages:
   flutter pub get
4. Run the app:
   flutter run

The generated android/ directory, local.properties, and build outputs are ignored by Git. Re-run the platform generation command after a clean clone or Flutter major template migration.

## Continuous integration
The Android foundation workflow generates the platform scaffold in the runner, resolves packages, checks formatting and static analysis, builds a debug APK, and uploads the APK as a workflow artifact. It does not sign or publish a release.

## Current limitation
The app is a visual foundation only. Account profile storage, cPanel network calls, and server operations are not implemented yet.
