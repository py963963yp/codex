# Repository Guidelines

## Project Overview

This repository is currently an empty project workspace. It contains no source
code, tests, assets, dependency manifest, or version-control history yet.
Contributors should establish conventions with the first implementation and
update this guide when tooling or directory structure is introduced.

## Project Structure & Module Organization

Keep new files at the repository root until a clear structure is needed. When
adding modules, create focused directories such as `src/`, `tests/`, and
`assets/`, and document their purposes here. Place generated output in a
dedicated, ignored directory; never commit build artifacts or secrets.

## Build, Test, and Development Commands

No build, test, or run command is currently defined. The first change that
introduces a language runtime or package manager must include a project
manifest, a short setup procedure, and the canonical commands for local
development. Record those commands here, for example:

```sh
npm install   # Install dependencies
npm test      # Run the test suite
npm run dev   # Start the local development server
```

Use the actual commands supplied by the project tooling.

## Coding Style & Naming Conventions

No formatter, linter, or language convention is established. Follow the
conventions of existing code once present, use consistent indentation, and add
the formatter and linter configuration in the same change that introduces the
primary language. Prefer descriptive file, directory, and symbol names; use
lowercase hyphenated names for documentation and shared configuration files.

## Testing Guidelines

No testing framework or coverage threshold exists yet. Add tests with each new
behavior, place them beside related code or under `tests/`, and use descriptive
names that state the expected behavior. Run the full test suite before
submitting a change and document the command here when the first test tool is
added.

## Commit & Pull Request Guidelines

There is no Git history from which to infer a commit convention. Use concise,
imperative commit subjects, such as `Add authentication form`. Keep commits
focused. Pull requests should explain the change, list verification steps,
link relevant issues, and include screenshots for visible interface changes.

## Security & Configuration

Keep credentials and environment-specific settings out of version control.
Provide safe example configuration instead, and note all required variables in
the project documentation.
