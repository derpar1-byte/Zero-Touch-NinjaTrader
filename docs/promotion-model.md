# Promotion model

This document describes a staged promotion path from CI artifacts through validated approval toward a future production environment.

## Current model

The repository currently supports:
- CI packaging on GitHub-hosted runners
- simulated deployment via `deploy-sim.yml`
- approved promotion via `promote.yml` into a validated target
- rollback via `rollback.yml`

## Recommended staged model

```text
Commit/PR
  -> ci.yml
  -> artifact + checksum
  -> deploy-sim.yml
  -> post-deploy-verify.yml
  -> promote.yml (validated approval gate)
  -> post-deploy-verify.yml
  -> future production promotion
```

## Environment intent

### `sim`
Use for:
- first deployment of a build artifact
- artifact resolution testing
- checksum validation
- operational rehearsals

### `validated`
Use for:
- human-reviewed promotion candidates
- pre-production signoff
- controlled verification before any live target exists

### `production` (future)
Recommended when you add live deployment:
- separate GitHub Environment named `production`
- stricter reviewer requirements than `validated`
- dedicated drop folder variable such as `NT8_PRODUCTION_DROP_FOLDER`
- dedicated post-deploy verification workflow run
- explicit rollback target retained for the previously deployed version

## Promotion rules

- only promote artifacts that passed CI
- prefer sim deployment before validated promotion
- require checksums for validated and production-like targets
- use dry-run when first wiring a new environment
- document operator approval in the release-readiness issue or release notes

## Future production extension

When adding production, consider:
- `promote-production.yml` reusing `_deploy-package.yml`
- `production` environment with required reviewers and optional wait timer
- separate runner labels if the production host differs
- stricter branch/tag policy for releases eligible for production

## Suggested variables

Current:
- `NT8_SIM_DROP_FOLDER`
- `NT8_VALIDATED_DROP_FOLDER`
- `NT8_LOG_FOLDER`

Future:
- `NT8_PRODUCTION_DROP_FOLDER`
- `NT8_PRODUCTION_LOG_FOLDER` (optional if logs are split by environment)
