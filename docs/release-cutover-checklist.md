# Release Cutover Checklist

Use this checklist for a controlled validated-to-production cutover.

## Before cutover
- [ ] CI is green for the target commit or tag.
- [ ] Release artifact and `.sha256` checksum are present.
- [ ] `promote.yml` has already succeeded for the target package.
- [ ] `post-deploy-verify.yml` has succeeded against the validated environment.
- [ ] `production` environment reviewers are available.
- [ ] `NT8_PRODUCTION_DROP_FOLDER` is configured and confirmed.
- [ ] A prior known-good production artifact is identified for rollback.
- [ ] `rollback-production.yml` has been reviewed and can be run in dry-run mode.

## Cutover execution
- [ ] Run `promote-production.yml` with `dry_run = true`.
- [ ] Confirm the resolved package and checksum match expectations.
- [ ] Approve the `production` environment gate.
- [ ] Run `promote-production.yml` with `dry_run = false`.
- [ ] Confirm deployment logs were written.
- [ ] Run `post-deploy-verify.yml` against the production drop/log folders with checksum validation enabled.

## After cutover
- [ ] Confirm expected package exists in the production drop folder.
- [ ] Confirm checksum verification passed.
- [ ] Confirm operator smoke checks passed in the production environment.
- [ ] Record the promotion outcome in release notes or incident/change tracking.
- [ ] If needed, prepare `rollback-production.yml` inputs for rapid recovery.

## If cutover fails
- [ ] Stop additional promotions.
- [ ] Identify whether the issue is packaging, checksum, environment, or runner related.
- [ ] Run `rollback-production.yml` with `dry_run = true` against the last known-good package.
- [ ] If resolution is correct, run `rollback-production.yml` with `dry_run = false`.
- [ ] Document findings and next corrective actions.
