# Release Notes Example: v1.0.0

Use this as a starting point when publishing the first tagged release.

## Summary
Initial baseline release of the Zero-Touch-NinjaTrader delivery scaffold. This release establishes the .NET solution, GitHub Actions automation, packaging flow, deployment/promotion workflows, and operator documentation needed to manage supervised NinjaTrader 8 artifact delivery.

## Added
- .NET 8 solution with shared configuration validation code and unit tests.
- GitHub Actions CI workflow for restore, build, test, config validation, packaging, and artifact upload.
- Reusable build/package workflow and reusable deploy workflow.
- Manual deployment workflow for sim delivery on Windows self-hosted runners.
- Manual validated promotion workflow using GitHub Environment approvals.
- Production promotion scaffold and production rollback scaffold.
- Rollback, post-deploy verification, and release workflows.
- SHA-256 checksum generation and validation during package handling.
- Runner, rollback, cutover, hotfix, release, promotion, and operator documentation.
- Governance files including CODEOWNERS, PR template, issue templates, CONTRIBUTING, and SECURITY.
- Dependabot and CodeQL hardening workflows.

## Changed
- Standardized release tags in `v<major>.<minor>.<patch>` format while normalizing package versions to `<major>.<minor>.<patch>`.
- Centralized common build settings in `Directory.Build.props` and SDK expectations in `global.json`.

## Fixed
- Resolved xUnit test compilation by restoring the required `using Xunit;` import.
- Clarified the .NET 8 runtime requirement for local and runner-based test execution.

## Security
- Added guidance for protected branches, environment approvals, manual workflow restrictions, and self-hosted runner hardening.
- Added CodeQL analysis and Dependabot workflow update monitoring.

## Deployment notes
- CI status: expected to pass on .NET 8 with packaging and checksum artifacts produced.
- Sim deployment validation: run `deploy-sim.yml` with `dry_run=true` before the first live copy.
- Promotion impact: validate `promote.yml` approval flow using the `validated` environment.
- Checksum/integrity notes: confirm `.sha256` files are published and verified during deploy/promote/rollback.

## Upgrade or rollback guidance
- For first release adoption, validate sim deployment and post-deploy verification before any higher-environment promotion.
- If deployment behavior is unexpected, use `rollback.yml` or `rollback-production.yml` in dry-run mode first, then perform an approved rollback to the last known-good artifact.
