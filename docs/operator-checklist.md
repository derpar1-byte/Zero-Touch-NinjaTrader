# Operator Checklist

Use this checklist on release day, deployment day, or promotion day.

## Pre-flight

- [ ] `main` is green in GitHub Actions
- [ ] required reviewers for `validated` are available
- [ ] self-hosted runner is online and labeled `self-hosted`, `windows`, `nt8`
- [ ] .NET 8 SDK/runtime still resolve correctly on the runner
- [ ] deployment folders exist and are writable
- [ ] latest `CHANGELOG.md` and release notes are ready
- [ ] rollback target is known for the currently deployed version

## Release tag readiness

- [ ] intended version follows semantic tag format like `v1.0.0`
- [ ] `docs/release-process.md` reviewed
- [ ] `.github/release-notes-template.md` prepared for the release
- [ ] prior known-good artifact is still available if rollback is needed

## CI/package validation

- [ ] CI restore/build/test succeeded
- [ ] package zip artifact exists
- [ ] `.sha256` checksum artifact exists
- [ ] package contents match intended strategy/indicator payload

## Sim deployment

- [ ] `deploy-sim.yml` dry run succeeded
- [ ] real sim deployment succeeded
- [ ] deployment log was written
- [ ] checksum validation passed when applicable
- [ ] post-deploy health check passed

## Promotion / validated deployment

- [ ] promotion dry run succeeded
- [ ] validated approval reviewers confirmed
- [ ] real promotion succeeded
- [ ] validated drop folder contains the intended package
- [ ] checksum validation passed when applicable
- [ ] post-promotion health check passed

## Rollback readiness

- [ ] `rollback.yml` dry run can resolve the selected fallback package
- [ ] fallback checksum file is available when expected
- [ ] operators know the exact artifact/package to restore if needed

## Post-release / post-deploy

- [ ] GitHub Release published if applicable
- [ ] deployment outcome documented
- [ ] any manual NT8 import/verification steps completed
- [ ] follow-up issues captured for anything abnormal
