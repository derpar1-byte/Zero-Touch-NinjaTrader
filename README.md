[![CI](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/ci.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/ci.yml)
[![Release](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/release.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/release.yml)
[![Deploy Sim](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/deploy-sim.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/deploy-sim.yml)
[![Promote](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote.yml)
[![Rollback](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback.yml)
[![CodeQL](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/codeql.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/codeql.yml)

# Zero-Touch-NinjaTrader

GitHub Actions automation scaffold for a NinjaTrader 8 strategy delivery pipeline with build validation, packaging, simulated deployment, and supervised promotion gates.

## What this repository provides

- .NET solution for shared config and validation logic
- GitHub Actions CI workflow for restore, build, test, config validation, and packaging
- Windows self-hosted runner deployment workflow for sim/paper delivery
- Promotion workflow with manual approval through GitHub Environments
- PowerShell packaging script for NinjaTrader-style import/export zip artifacts
- Basic health checks and deployment logging
- checksum verification during deploy/promote when `.sha256` files are supplied
- health checks that can require checksum presence

## Repository layout

```text
.github/workflows/
  ci.yml
  deploy-sim.yml
  promote.yml
deploy/
  deploy-sim.ps1
  health-check.ps1
  package-nt8.ps1
src/
  Common/
  ConfigValidatorCli/
tests/
  Common.Tests/
ZeroTouchNinjaTrader.sln
```

## Prerequisites

### GitHub

- A GitHub repository containing this project
- Actions enabled
- A GitHub Environment named `sim`
- A GitHub Environment named `validated` for promotion approvals
- Required reviewers configured on `validated` if you want a manual approval gate

### Runner machine

Use a Windows self-hosted runner for deployment steps that interact with NinjaTrader conventions.

Install on the runner machine:
- .NET 8 SDK and .NET 8 runtime
- PowerShell 7+ recommended
- NinjaTrader 8
- GitHub Actions self-hosted runner service

Recommended folders on the runner:
- `C:\NinjaTraderDeploy\Import`
- `C:\NinjaTraderDeploy\Validated`
- `C:\NinjaTraderDeploy\Logs`
- `C:\NinjaTraderDeploy\Staging`
- `C:\NinjaTraderDeploy\Exports`

## Configuration

### Repository or environment variables

Set these GitHub variables for the self-hosted deployment workflows:

- `NT8_SIM_DROP_FOLDER` — destination folder for sim packages
- `NT8_VALIDATED_DROP_FOLDER` — destination folder for approved promotion packages
- `NT8_LOG_FOLDER` — deployment log folder
- `NT8_STAGING_FOLDER` — optional temporary packaging workspace
- `NT8_EXPORTS_FOLDER` — optional output folder for packaged zip files

Example values:

```text
NT8_SIM_DROP_FOLDER=C:\NinjaTraderDeploy\Import
NT8_VALIDATED_DROP_FOLDER=C:\NinjaTraderDeploy\Validated
NT8_LOG_FOLDER=C:\NinjaTraderDeploy\Logs
NT8_STAGING_FOLDER=C:\NinjaTraderDeploy\Staging
NT8_EXPORTS_FOLDER=C:\NinjaTraderDeploy\Exports
```

### Application config

Edit `src/Common/appsettings.json`:

```json
{
  "name": "ZeroTouchNinjaTrader",
  "version": "1.0.0",
  "strategyName": "SampleStrategy",
  "targetEnvironment": "sim",
  "artifactRoot": "artifacts",
  "dropFolder": "C:\\NinjaTraderDeploy\\Import",
  "logFolder": "C:\\NinjaTraderDeploy\\Logs"
}
```

## Release process

Release tagging and packaging conventions are documented in `docs/release-process.md`.
Hotfix guidance is documented in `docs/hotfix-process.md`.
Promotion path guidance is documented in `docs/promotion-model.md`.
Rollback guidance is documented in `docs/rollback.md`.
Runner maintenance guidance is documented in `docs/runner-ops.md`.
Release/deploy day guidance is documented in `docs/operator-checklist.md`.
Post-deploy verification guidance is documented in `docs/post-deploy-checklist.md`.

## Workflow summary table

| Workflow | Trigger | Runner | Purpose |
|---|---|---|---|
| `ci.yml` | push, pull_request, tag | GitHub-hosted Windows | restore, build, test, validate, package, upload artifacts |
| `release.yml` | `v*` tag | GitHub-hosted Windows | package release artifacts and publish GitHub Release |
| `deploy-sim.yml` | manual | self-hosted Windows (`nt8`) | deploy selected artifact to sim target |
| `promote.yml` | manual | self-hosted Windows (`nt8`) | promote artifact to validated target with approval gate |
| `rollback.yml` | manual | self-hosted Windows (`nt8`) | redeploy a previous known-good artifact |
| `post-deploy-verify.yml` | manual | self-hosted Windows (`nt8`) | rerun post-deploy health and checksum verification |
| `codeql.yml` | push, pull_request, weekly | GitHub-hosted Windows | static analysis and security scanning |
| `_build-package.yml` | reusable | GitHub-hosted Windows | shared restore/build/test/package logic |
| `_deploy-package.yml` | reusable | self-hosted Windows (`nt8`) | shared deploy/promote/rollback logic |

## Workflow overview

### `ci.yml`

Runs on push, pull request, and version tags:
- restore solution
- build solution
- run tests
- validate config
- read package metadata from `appsettings.json`
- package NinjaTrader payload into versioned and latest zip artifacts
- upload build artifacts

Artifact outputs include:
- `artifacts/exports/<package>-<strategy>-<version>-<timestamp>.zip`
- `artifacts/exports/<package>-<strategy>-<version>-<timestamp>.zip.sha256`
- `artifacts/packages/<package>-<strategy>-latest.zip`

### `_deploy-package.yml`

Reusable workflow used by manual deployment and promotion:
- downloads the selected artifact bundle
- resolves the requested package file or newest `*-latest.zip`
- resolves and verifies the matching checksum file when present
- supports `dry_run` mode for first-time runner validation without copying files
- copies package/checksum to the target Windows drop folder when not in dry run
- runs post-deploy health checks with optional checksum enforcement

### `deploy-sim.yml`

Runs manually:
- downloads a selected artifact bundle from CI
- resolves either a specific package file or the newest `*-latest.zip`
- discovers a matching `<package>.zip.sha256` file when present
- copies package to the sim drop folder on the Windows runner
- copies and validates the checksum when present
- writes deployment logs
- runs a post-deploy health check that revalidates the checksum when used

Runner labels expected:
- `self-hosted`
- `windows`
- `nt8`

### `promote.yml`

Runs manually:
- targets GitHub Environment `validated`
- pauses for manual approval if required reviewers are configured
- downloads a selected artifact
- resolves either a specific package file or the newest `*-latest.zip`
- discovers a matching `<package>.zip.sha256` file when present
- supports `dry_run` for approval-path validation without copying files
- copies package to the validated drop folder
- copies and validates the checksum when present
- runs post-promotion health validation that revalidates the checksum when used

### `rollback.yml`

Runs manually:
- targets GitHub Environment `validated`
- redeploys a specific previously known package file
- defaults to `dry_run = true` for safer first execution
- can be used to validate rollback resolution before copying files

### `post-deploy-verify.yml`

Runs manually on the Windows self-hosted runner:
- executes `deploy/health-check.ps1` against a chosen drop/log folder pair
- can require checksum validation
- provides a lightweight verification pass after deploy, promote, or rollback

### `_build-package.yml`

Reusable workflow used by CI and release automation:
- restores, builds, tests, and validates the solution
- packages the NinjaTrader artifact with a supplied version
- generates checksum files
- optionally uploads artifacts for downstream workflows

### `release.yml`

Runs on version tags:
- restores, builds, and tests the solution
- normalizes tag versions like `v1.0.0` to package version `1.0.0`
- packages release artifacts using the normalized semantic version
- generates checksum files
- publishes a GitHub Release with attached artifacts

### `codeql.yml`

Runs on pushes, pull requests, and a weekly schedule:
- initializes CodeQL for C#
- builds the solution
- publishes static analysis results to GitHub Security

## PowerShell packaging convention

`deploy/package-nt8.ps1` creates a NinjaTrader-style zip package for supervised import workflows.

Packaging flow:
1. resolve source and output paths
2. create a clean staging directory
3. create `NinjaTrader 8\bin\Custom` under staging
4. copy `.cs`, `.xml`, and `.json` payload files into `bin\Custom`
5. emit `package-manifest.json`
6. emit `IMPORT-INSTRUCTIONS.txt`
7. create a versioned zip under `artifacts/exports`
8. copy a rolling latest zip under `artifacts/packages`
9. expose package paths as GitHub Actions outputs

Example local command:

```powershell
pwsh .\deploy\package-nt8.ps1 `
  -SourceRoot .\src `
  -OutputRoot .\artifacts `
  -StrategyName SampleStrategy `
  -PackageName ZeroTouchNinjaTrader `
  -Version 1.0.0
```

## Project structure

```text
.github/workflows/     CI, deployment, and promotion workflows
build/                 optional future build helpers
deploy/                packaging, deployment, and health-check scripts
src/Common/            shared config and validation code
src/Strategy/          strategy scaffold placeholders
src/Indicators/        indicator scaffold placeholders
tests/Common.Tests/    unit tests
```

## Repository governance

- `CODEOWNERS` assigns default review ownership for workflows, deploy scripts, source, tests, and docs.
- Pull requests use `.github/pull_request_template.md`.
- Issues use the YAML forms under `.github/ISSUE_TEMPLATE/`.
- Contribution expectations are documented in `CONTRIBUTING.md`.
- Security reporting and hardening guidance are documented in `SECURITY.md`.
- Release readiness can be tracked with `.github/ISSUE_TEMPLATE/release_readiness.yml`.

## Branch protection and repository settings checklist

Recommended settings for `main`:
- set `main` as the default branch
- require pull requests before merging
- require at least 1 approval
- require status checks before merging
- require conversation resolution before merging
- require review from code owners
- block direct pushes after bootstrap

Recommended GitHub Actions settings:
- allow GitHub Actions to read repository contents by default
- grant `contents: write` only to workflows that create releases
- grant `security-events: write` only to CodeQL workflows that need it
- restrict who can manually run deployment, rollback, and promotion workflows
- prefer environment-scoped secrets/variables for deploy targets
- enable Dependabot for GitHub Actions version updates
- enable CodeQL analysis for ongoing static security scanning
- review reusable workflow changes with the same scrutiny as deployment code
- keep rollback and promote permissions limited to trusted maintainers

Recommended environment settings:
- create `sim` for deployment testing if you want environment-level controls there
- create `validated` for promotion approvals
- require reviewers on `validated`
- optionally add a wait timer on `validated`

## License

This project is licensed under the MIT License. See `LICENSE`.

## Repo-level .NET settings

This repository includes:
- `global.json` to pin expected .NET 8 SDK behavior
- `Directory.Build.props` to centralize common build settings across projects

Why this matters:
- reduces "works on my machine" SDK drift
- keeps all projects aligned on `net8.0`, nullable, implicit usings, and deterministic builds
- makes GitHub-hosted CI and Windows self-hosted runners more predictable


## Versioning and changelog

- Update `src/Common/appsettings.json` for package name, strategy name, and version.
- Create tags like `v1.0.0` to trigger tag-aware CI packaging.
- Track notable user-facing changes in `CHANGELOG.md`.

## Runner setup guide

### 1. Create the self-hosted runner

- go to GitHub repository settings
- open **Actions > Runners**
- add a **self-hosted Windows** runner
- install it as a service
- assign labels:
  - `self-hosted`
  - `windows`
  - `nt8`

### 2. Install software

Install and verify:

```powershell
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes
pwsh --version
```

Install NinjaTrader 8 and confirm the machine can access your intended local folders.

### 3. Prepare deployment folders

```powershell
New-Item -ItemType Directory -Force -Path C:\NinjaTraderDeploy\Import
New-Item -ItemType Directory -Force -Path C:\NinjaTraderDeploy\Validated
New-Item -ItemType Directory -Force -Path C:\NinjaTraderDeploy\Logs
New-Item -ItemType Directory -Force -Path C:\NinjaTraderDeploy\Staging
New-Item -ItemType Directory -Force -Path C:\NinjaTraderDeploy\Exports
```

### 4. Configure GitHub variables and environments

Add the variables listed above.

Create environments:
- `sim`
- `validated`

For `validated`, configure required reviewers to enforce manual approval before promotion jobs start.

### 5. Validate the runner

Run the CI workflow, then dispatch `deploy-sim.yml`.

Expected outcomes:
- a versioned zip package is created
- a rolling latest package is created
- the selected package is copied into the sim import folder
- the checksum file is copied and validated when supplied
- a deployment log is written
- `health-check.ps1` reports the newest zip and log file

## Next customization points

Replace the scaffolded packaging logic with your exact NinjaTrader layout:
- specific strategy and indicator folders under `src/Strategy` and `src/Indicators`
- export structure expected by your NT8 import process
- signing or hashing if desired
- additional pre-deploy validation
- stronger audit logging
- artifact retention and rollback handling

You may also want to add:
- version stamping from git tags into `appsettings.json`
- release notes generation
- sim-only config overlays
- runner disk space checks
- checksums for package integrity

## Safety note

This repository is set up for build, validation, packaging, and supervised environment promotion. Keep live trading controls, approvals, monitoring, and kill switches outside of unattended code promotion.

