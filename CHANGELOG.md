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
- GitHub Release workflow for `v*` tags.
- Branch protection, workflow permission, and hardening guidance in project documentation.
- Dependabot configuration for GitHub Actions updates.
- CodeQL workflow for scheduled and PR/push static analysis.
- Reusable build/package workflow to reduce duplication across CI and release automation.
- MIT license file.
- Reusable deploy/promote workflow to reduce duplication across self-hosted deployment jobs.
- README status badges for CI, release, and CodeQL workflows.
- Semantic release process documentation with tag examples.
- Visible README status badges for deploy and promote workflows.
- Dry-run mode for reusable deployment workflow validation.
- Rollback workflow and rollback operations documentation.
- GitHub release notes template.
- Windows self-hosted runner operations playbook.
- Release/deploy day operator checklist.
- Release readiness issue template.
- Post-deploy verification workflow and checklist.
- Hotfix process documentation.
- Staged promotion model documentation for validated-to-production evolution.
- Workflow summary table in the README.
- Production promotion workflow scaffold.
- Production environment checklist documentation.
- README badges for post-deploy verification and production promotion workflows.
- Production rollback workflow scaffold.
- Release cutover checklist documentation.
- Documentation index page under `docs/README.md`.
- Root README documentation navigation section.
- Workflow input/output reference table in README.
- Incident response runbook for failed promotions and rollbacks.

### Fixed
- xUnit test compilation by restoring the required `using Xunit;` import.
- Runner documentation to call out the required .NET 8 runtime for `dotnet test`.
