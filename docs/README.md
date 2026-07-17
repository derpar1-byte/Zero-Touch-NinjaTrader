# Documentation Index

This directory contains the operational and release-management documentation for `Zero-Touch-NinjaTrader`.

## Release and versioning
- [release-process.md](release-process.md) - semantic version tagging, packaging expectations, release notes guidance, and rollback readiness.
- [hotfix-process.md](hotfix-process.md) - expedited patch-release process for urgent fixes.
- [promotion-model.md](promotion-model.md) - current sim-to-validated model and future validated-to-production evolution.
- [release-notes-v1.0.0-example.md](release-notes-v1.0.0-example.md) - sample GitHub Release notes for the first tagged release.

## Deployment and rollback
- [rollback.md](rollback.md) - rollback principles, artifact selection, and rollback workflow usage.
- [post-deploy-checklist.md](post-deploy-checklist.md) - automated and manual verification steps after deploy, promote, or rollback.
- [release-cutover-checklist.md](release-cutover-checklist.md) - cutover execution and fallback checklist.
- [production-environment-checklist.md](production-environment-checklist.md) - prerequisites and controls for enabling production promotion.
- [promotion-rollback-incident-runbook.md](promotion-rollback-incident-runbook.md) - incident runbook for failed promotions and rollbacks.
- [workflow-troubleshooting-matrix.md](workflow-troubleshooting-matrix.md) - symptom-based workflow failure lookup table.

## Operations
- [runner-ops.md](runner-ops.md) - Windows self-hosted runner maintenance and troubleshooting.
- [operator-checklist.md](operator-checklist.md) - release/deploy day operator checklist.

## Suggested reading order

### New operator / first-time setup
1. `../README.md`
2. `production-environment-checklist.md`
3. `runner-ops.md`
4. `promotion-model.md`
5. `operator-checklist.md`

### Release planning and execution
1. `release-process.md`
2. `hotfix-process.md`
3. `release-cutover-checklist.md`
4. `post-deploy-checklist.md`
5. `rollback.md`

### Incident and recovery
1. `promotion-rollback-incident-runbook.md`
2. `workflow-troubleshooting-matrix.md`
3. `rollback.md`
4. `runner-ops.md`

## Documentation index
