[![CI](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/ci.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/ci.yml)
[![Release](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/release.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/release.yml)
[![Deploy Sim](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/deploy-sim.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/deploy-sim.yml)
[![Promote](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote.yml)
[![Rollback](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback.yml)
[![Post-Deploy Verify](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/post-deploy-verify.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/post-deploy-verify.yml)
[![Promote Production](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote-production.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/promote-production.yml)
[![Rollback Production](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback-production.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/rollback-production.yml)
[![CodeQL](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/codeql.yml/badge.svg)](https://github.com/derpar1-byte/Zero-Touch-NinjaTrader/actions/workflows/codeql.yml)

# Zero-Touch-NinjaTrader

.NET 8 and PowerShell starter for a NinjaTrader 8 delivery pipeline: validate package config, stage NinjaTrader-compatible source payloads, package zip/checksum artifacts, deploy to sim, promote with gates, verify health, and support rollback scaffolds.

## What this repository provides

- .NET solution with shared config validation, artifact naming helpers, packaging manifest generation, and CLI validation.
- NinjaTrader-style package staging under `NinjaTrader 8/bin/Custom/Strategies`, `NinjaTrader 8/bin/Custom/Indicators`, and `AddOnContent`.
- PowerShell scripts for deterministic packaging, checksum generation, dry-run deployment, checksum validation, structured logs, and health checks.
- GitHub Actions workflows for CI, tag releases, sim deploy, validated promotion, production promotion scaffolds, rollback, and post-deploy verification.
- Operator docs for release, hotfix, rollback, runner ops, troubleshooting, permissions, and artifact naming.

## Repository layout

```text
.github/workflows/        CI, release, deploy, promote, rollback, and reusable workflows
config/                   package/deployment config used by scripts and CLI validation
deploy/                   package, deploy, and health-check PowerShell scripts
docs/                     operator and workflow documentation
src/Common/               config model, validation, version/artifact/checksum helpers
src/Strategy/             strategy metadata scaffold
src/Indicators/           indicator metadata scaffold, plus PositionExporter.cs
                          (a real, hand-written NinjaScript indicator for the
                          Northstar NT8 bridge -- NOT staged by src/Packaging/;
                          import it manually, see the file's header comment)
src/Packaging/            manifest and NinjaTrader payload staging service
src/ConfigValidatorCli/   CLI config validator
tests/Common.Tests/       fast deterministic unit tests
ZeroTouchNinjaTrader.sln
```

## Prerequisites

- .NET 8 SDK
- PowerShell 7+ recommended, Windows PowerShell works for local scripts
- Windows self-hosted GitHub runner with labels `self-hosted`, `windows`, `nt8` for deploy/promote jobs
- NinjaTrader 8 on operator machines that will manually import the generated zip

## Configuration

Edit `config/deploy-settings.json`:

```json
{
  "packageName": "ZeroTouchNinjaTrader",
  "version": "0.1.0",
  "strategyName": "ZeroTouchSampleStrategy",
  "indicatorNames": ["ZeroTouchTrendFilter", "ZeroTouchRiskMeter"],
  "targetEnvironment": "sim",
  "artifactRoot": "artifacts",
  "exportRoot": "artifacts/export",
  "packageRoot": "artifacts/package",
  "dropFolder": "artifacts/sim-drop",
  "logFolder": "artifacts/logs",
  "ninjaTraderRelativeRoot": "NinjaTrader 8/bin/Custom"
}
```

Validate it locally:

```powershell
dotnet run --project .\src\ConfigValidatorCli\ConfigValidatorCli.csproj -- .\config\deploy-settings.json
```

## Local build and package

```powershell
dotnet restore .\ZeroTouchNinjaTrader.sln
dotnet build .\ZeroTouchNinjaTrader.sln -c Release
dotnet test .\ZeroTouchNinjaTrader.sln -c Release

.\deploy\package-nt8.ps1 -ConfigPath .\config\deploy-settings.json -Version 1.0.0
```

Package output names follow `docs/release-artifact-naming-reference.md`:

```text
artifacts/export/ZeroTouchNinjaTrader-ZeroTouchSampleStrategy-1.0.0.zip
artifacts/export/ZeroTouchNinjaTrader-ZeroTouchSampleStrategy-1.0.0.zip.sha256
artifacts/package/ZeroTouchNinjaTrader-ZeroTouchSampleStrategy-latest.zip
artifacts/package/ZeroTouchNinjaTrader-ZeroTouchSampleStrategy-latest.zip.sha256
```

Zip layout:

```text
NinjaTrader 8/bin/Custom/Strategies/<strategy>.cs
NinjaTrader 8/bin/Custom/Indicators/<indicator>.cs
AddOnContent/package-summary.txt
package-manifest.json
IMPORT-INSTRUCTIONS.txt
```

## GitHub variables and environments

Set these GitHub variables for self-hosted deployment workflows:

- `NT8_SIM_DROP_FOLDER`
- `NT8_VALIDATED_DROP_FOLDER`
- `NT8_PRODUCTION_DROP_FOLDER`
- `NT8_LOG_FOLDER`

Recommended environments:

- `sim`
- `validated` with required reviewers
- `production` with stricter required reviewers

## Workflow summary

| Workflow | Trigger | Purpose |
|---|---|---|
| `ci.yml` | push, pull_request | restore, build, test, validate config, package/upload artifacts |
| `release.yml` | `v*` tag | normalize `v1.0.0` to `1.0.0`, package, publish release assets |
| `deploy-sim.yml` | manual | deploy selected artifact to sim drop folder, supports dry-run |
| `promote.yml` | manual | approval-gated deploy to validated folder |
| `promote-production.yml` | manual | approval-gated deploy to production folder |
| `rollback.yml` | manual | redeploy specified prior package to sim path |
| `rollback-production.yml` | manual | redeploy specified prior production package |
| `post-deploy-verify.yml` | manual | run health/checksum/log verification on a target folder |
| `_build-package.yml` | reusable | shared build/test/package implementation |
| `_deploy-package.yml` | reusable | shared artifact resolution, deploy, and health-check implementation |

## Documentation navigation

- Full docs index: `docs/README.md`
- Release process: `docs/release-process.md`
- Hotfix process: `docs/hotfix-process.md`
- Rollback: `docs/rollback.md`
- Runner operations: `docs/runner-ops.md`
- Troubleshooting: `docs/workflow-troubleshooting-matrix.md`
- Workflow permissions: `docs/workflow-permissions-matrix.md`
- Artifact naming: `docs/release-artifact-naming-reference.md`
- Production setup: `docs/production-environment-checklist.md`

## Safety note

This repository is for build, validation, packaging, and supervised environment promotion. Keep live trading controls, approvals, monitoring, account permissions, and kill switches outside unattended code promotion.
