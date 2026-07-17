# Promotion and Rollback Incident Runbook

## Purpose

Use this runbook when a validated or production promotion fails, a rollback fails, or a post-deploy verification step indicates that the target environment is not in a safe state.

## Immediate triage

1. Stop additional deploy, promote, or rollback attempts until the current failure is understood.
2. Capture the failing workflow run URL.
3. Record:
   - workflow name
   - artifact name
   - package file
   - target environment
   - whether `dry_run` was used
   - whether checksum validation was required
4. Determine whether the failure occurred during:
   - artifact resolution
   - checksum resolution or validation
   - file copy/deployment
   - post-deploy verification
   - environment approval / runner execution

## Common failure modes

### 1. Artifact or package cannot be resolved

Symptoms:
- workflow cannot find the artifact bundle
- workflow cannot find the expected package file
- latest package resolution picks nothing

Actions:
1. Confirm the upstream `ci.yml` or `release.yml` run completed successfully.
2. Confirm the artifact name matches the uploaded artifact bundle.
3. If using `package_file`, verify the exact file name inside the artifact bundle.
4. Re-run in `dry_run=true` mode first.
5. If needed, select a different known-good artifact.

Rollback path:
- abort the failed promotion
- use `rollback.yml` or `rollback-production.yml` with a known-good package in `dry_run=true`

### 2. Checksum file missing or mismatched

Symptoms:
- `.sha256` not found
- checksum malformed
- computed SHA-256 does not match expected value

Actions:
1. Confirm the artifact bundle includes both the package zip and matching `.sha256`.
2. Verify the checksum file corresponds to the selected package file.
3. Do not continue with manual copy if checksum validation fails.
4. Select a different known-good artifact if integrity is uncertain.

Rollback path:
- do not promote the suspect artifact
- fall back to the previous release artifact with verified checksum

### 3. Self-hosted runner or permissions failure

Symptoms:
- runner offline
- job never starts on expected labels
- access denied to drop/log folders

Actions:
1. Confirm runner is online and labeled correctly: `self-hosted`, `windows`, `nt8`.
2. Confirm the environment approval was granted.
3. Confirm folder permissions for the runner service account.
4. Validate runner health using `docs/runner-ops.md`.
5. Re-run in `dry_run=true` mode to confirm workflow wiring before a real copy.

Rollback path:
- if no files were copied, resolve runner state first
- if partial copy occurred, verify folder contents and redeploy a known-good artifact

### 4. Post-deploy verification failed

Symptoms:
- `deploy/health-check.ps1` fails
- expected package or checksum not present in target folder
- deployment log missing

Actions:
1. Inspect the latest files in the target drop folder.
2. Inspect the latest deployment log under `NT8_LOG_FOLDER`.
3. Run `post-deploy-verify.yml` against the target folder.
4. Confirm the checksum file matches the deployed package.
5. If the environment is unsafe or ambiguous, prepare rollback immediately.

Rollback path:
- run the appropriate rollback workflow in `dry_run=true`
- if dry-run resolves correctly, rerun with `dry_run=false`
- verify with `post-deploy-verify.yml` after rollback

## Environment-specific response

### Validated promotion failure
- primary workflow: `promote.yml`
- rollback workflow: `rollback.yml`
- target review point: validated environment approval and `NT8_VALIDATED_DROP_FOLDER`

### Production promotion failure
- primary workflow: `promote-production.yml`
- rollback workflow: `rollback-production.yml`
- target review point: production environment approval and `NT8_PRODUCTION_DROP_FOLDER`

## Escalation guidance

Escalate immediately when:
- checksum validation fails for a release candidate
- a production copy may have occurred but verification is inconclusive
- runner access or folder permissions changed unexpectedly
- multiple sequential artifacts fail the same step

Escalation package should include:
- workflow run URL
- artifact and package names
- checksum status
- deployment log excerpt
- current rollback recommendation

## Recovery completion checklist

- [ ] failing workflow run documented
- [ ] root failure mode identified
- [ ] known-good artifact identified
- [ ] dry-run verification completed
- [ ] rollback or corrected promotion completed
- [ ] post-deploy verification passed
- [ ] follow-up documentation/task created if process improvement is needed
