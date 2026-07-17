# Production environment checklist

Use this checklist before enabling a full validated-to-production promotion path.

## Environment model

Recommended environments:
- `sim`
- `validated`
- `production`

Intent:
- `sim` validates packaging and deployment mechanics
- `validated` confirms human-reviewed readiness
- `production` is the final controlled rollout target

## GitHub configuration

### Environments
Create or verify:
- `validated`
- `production`

Recommended `production` protections:
- required reviewers
- optional wait timer
- restricted manual dispatch access
- environment-scoped secrets or variables only

### Variables
Add or verify:
- `NT8_SIM_DROP_FOLDER`
- `NT8_VALIDATED_DROP_FOLDER`
- `NT8_PRODUCTION_DROP_FOLDER`
- `NT8_LOG_FOLDER`
- `NT8_STAGING_FOLDER`
- `NT8_EXPORTS_FOLDER`

Example:

```text
NT8_PRODUCTION_DROP_FOLDER=C:\NinjaTraderDeploy\Production
```

## Runner expectations

Recommended labels for the production-capable runner:
- `self-hosted`
- `windows`
- `nt8`

Additional recommendations:
- dedicate the runner to NT8 deployment work if possible
- restrict interactive access to trusted operators
- verify folder ACLs for production drop and log directories
- keep .NET, PowerShell, and the Actions runner updated

## Operational controls

Before enabling production promotion:
- confirm `deploy-sim.yml` works end to end
- confirm `promote.yml` works end to end
- confirm `rollback.yml` works end to end in dry-run and real modes
- confirm `post-deploy-verify.yml` works against validated targets
- confirm checksum validation is enabled and understood by operators
- confirm a prior known-good artifact is retained for rollback

## Documentation and process

Ensure operators know where to find:
- `docs/promotion-model.md`
- `docs/rollback.md`
- `docs/operator-checklist.md`
- `docs/post-deploy-checklist.md`
- `docs/runner-ops.md`

## Pre-go-live checklist

- [ ] `production` environment created in GitHub
- [ ] required reviewers configured
- [ ] production drop folder variable configured
- [ ] production folder exists on runner
- [ ] rollback artifact retention confirmed
- [ ] dry-run promotion tested
- [ ] post-deploy verification tested
- [ ] operator runbooks reviewed
