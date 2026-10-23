# Repository Guidelines

## Project Structure & Module Organization

Focus Flow is a Flutter application. Keep application code in `lib/`; shared
state and services belong in `lib/src/`. Widget and controller tests live in
`test/`. Android-specific configuration is under `android/`, while build and
release automation belongs in `.github/workflows/`. Do not commit generated
`build/`, `.dart_tool/`, or IDE files.

## Build, Test, and Development Commands

```sh
flutter pub get                  # Install Dart dependencies
flutter run                      # Run on a connected device or emulator
dart format lib test             # Format Dart source
flutter analyze                  # Run static analysis
flutter test                     # Run unit and widget tests
flutter build apk --release      # Build the Android release APK
```

The APK is written to `build/app/outputs/flutter-apk/app-release.apk`. Pushes
to `main`, pull requests, and manual workflow runs execute the same checks and
upload the artifact from `.github/workflows/android.yml`.

## Coding Style & Naming Conventions

Use the official Dart formatter and satisfy `flutter_lints` in
`analysis_options.yaml`. Follow the existing two-space indentation and trailing
commas. Name Dart files and directories with `snake_case`, classes with
`PascalCase`, and methods, variables, and enum values with `camelCase`. Keep
business logic out of widgets and inject `SessionStore` implementations at the
application boundary.

## Testing Guidelines

Add tests for timer transitions, controls, persistence, and visible behavior.
Use descriptive test names that state the expected outcome. Place controller
and model tests in `test/` using `flutter_test`, and run `flutter test` before
opening a pull request. New behavior should include a focused test or an
explanation of why a test is impractical.

## Commit & Pull Request Guidelines

Use concise, imperative commit subjects, such as `Add rest timer preset`, and
keep commits focused. Pull requests should explain user-visible changes, list
verification commands, link relevant issues, and include screenshots for UI
changes. Confirm that the Android APK workflow succeeds before merging.

## Security & Configuration

Keep credentials, signing keys, and `android/local.properties` out of version
control. The app requires no network permission in release builds. Add secrets
through GitHub Actions secrets and document any new configuration.
