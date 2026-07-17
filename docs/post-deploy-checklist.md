# Post-Deploy Verification

Use this checklist after a sim deployment, promotion, or rollback.

## Automated verification

- [ ] Run `.github/workflows/post-deploy-verify.yml` against the target environment
- [ ] Confirm `deploy/health-check.ps1` passes
- [ ] Confirm checksum validation passes when required

## Operator checks

- [ ] Correct package appears in the target drop folder
- [ ] Expected log entry appears in the log folder
- [ ] No unexpected checksum mismatch or missing file errors are present
- [ ] Manual NinjaTrader import or environment-specific validation succeeded
- [ ] Any environment-specific smoke checks passed

## Escalation

- [ ] If verification fails, stop forward promotion
- [ ] If needed, prepare `rollback.yml` with a known-good artifact
- [ ] Record the failure and affected artifact/package in your tracking system
