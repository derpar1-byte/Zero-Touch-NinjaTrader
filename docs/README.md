# Documentation Index

This directory contains the operational and release-management documentation for `Zero-Touch-NinjaTrader`.

## Release and versioning
- [release-process.md](release-process.md) - semantic version tagging, packaging expectations, release notes guidance, and rollback readiness.
- [hotfix-process.md](hotfix-process.md) - expedited patch-release process for urgent fixes.
- [promotion-model.md](promotion-model.md) - current sim-to-validated model and future validated-to-production evolution.

## Deployment and rollback
- [rollback.md](rollback.md) - rollback principles, artifact selection, and rollback workflow usage.
- [post-deploy-checklist.md](post-deploy-checklist.md) - automated and manual verification steps after deploy, promote, or rollback.
- [production-environment-checklist.md](production-environment-checklist.md) - prerequisites and controls for enabling production promotion.

## Operations
- [runner-ops.md](runner-ops.md) - Windows self-hosted runner maintenance and troubleshooting.
- [operator-checklist.md](operator-checklist.md) - release/deploy day operator checklist.

## Suggested reading order
1. `release-process.md`
2. `promotion-model.md`
3. `production-environment-checklist.md`
4. `rollback.md`
5. `operator-checklist.md`
6. `runner-ops.md`
