# FAQ

## What does this repository automate?
It provides a GitHub Actions-based delivery scaffold for NinjaTrader 8 packaging, validation, simulated deployment, supervised promotion, rollback, and release operations.

## Does this deploy directly into live trading?
No. The current model centers on CI packaging, sim deployment, validated promotion, and optional future production workflows. Production promotion is scaffolded but intentionally gated and dry-run-first.

## Why are there both versioned and latest packages?
Versioned packages support traceability and rollback. The rolling `latest` package supports easier manual selection for routine test deployments.

## Why are checksum files generated?
Checksum files help verify artifact integrity during deploy, promote, rollback, and post-deploy verification steps.

## What tag format should releases use?
Use semantic version tags like:
- `v1.0.0`
- `v1.1.0`
- `v1.1.1`

The release workflow normalizes `v1.0.0` to package version `1.0.0`.

## When should I use a hotfix tag?
Use a hotfix path for urgent, targeted fixes that should bypass a larger planned release train. See `docs/hotfix-process.md`.

## What is the difference between deploy, promote, and rollback?
- `deploy-sim.yml`: sends a package to the sim target
- `promote.yml`: sends an approved package to the validated target
- `rollback.yml`: re-deploys a previously known-good artifact
- production variants apply the same pattern to the future production lane

## What is dry-run mode for?
Dry-run mode validates artifact resolution, checksum resolution, environment wiring, and intended target paths without copying files.

## What runner labels are expected?
Self-hosted deployment workflows expect:
- `self-hosted`
- `windows`
- `nt8`

## What GitHub variables are required?
At minimum:
- `NT8_SIM_DROP_FOLDER`
- `NT8_VALIDATED_DROP_FOLDER`
- `NT8_LOG_FOLDER`

For production scaffolds also set:
- `NT8_PRODUCTION_DROP_FOLDER`

## Where should I start if something fails?
Use:
- `docs/workflow-troubleshooting-matrix.md`
- `docs/promotion-rollback-incident-runbook.md`
- `docs/runner-ops.md`

## Where are the operator-facing docs?
Start with:
- `docs/README.md`
- `docs/operator-checklist.md`
- `docs/release-cutover-checklist.md`
- `docs/post-deploy-checklist.md`
