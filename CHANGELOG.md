# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project loosely follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- GitHub Actions CI workflow for restore, build, test, and package steps.
- Sim deployment workflow for Windows self-hosted NinjaTrader runners.
- Manual promotion workflow using the `validated` environment approval gate.
- NinjaTrader packaging scaffold with manifest and import instructions.
- Centralized repo-level .NET settings via `global.json` and `Directory.Build.props`.
- Runner setup documentation and NT8 deployment variable guidance.
- Basic config validation library, CLI, and unit tests.
- PR template, issue templates, and `CODEOWNERS` governance scaffolding.
- `CONTRIBUTING.md` and `SECURITY.md` repository policy scaffolding.

### Fixed
- xUnit test compilation by restoring the required `using Xunit;` import.
- Runner documentation to call out the required .NET 8 runtime for `dotnet test`.
