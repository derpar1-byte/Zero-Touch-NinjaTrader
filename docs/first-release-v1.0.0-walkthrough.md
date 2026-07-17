# First Release Walkthrough: v1.0.0

This walkthrough provides a concrete first tagged release path for `v1.0.0`.

## Prerequisites

- `main` contains the intended release commit
- required GitHub variables are configured
- self-hosted Windows runner is online with labels:
  - `self-hosted`
  - `windows`
  - `nt8`
- `validated` environment exists with reviewers if promotion approval is desired
- optional production scaffolds are configured only if you plan to validate them

## 1. Confirm local validation

Run:

```powershell
dotnet restore .\ZeroTouchNinjaTrader.sln
dotnet build .\ZeroTouchNinjaTrader.sln -c Release
dotnet test .\ZeroTouchNinjaTrader.sln -c Release
```

Expected outcome:
- restore/build/test all succeed

## 2. Update release-facing docs

Before tagging:
- confirm `CHANGELOG.md` reflects the release scope
- prepare notes using `.github/release-notes-template.md`
- optionally review `docs/release-notes-v1.0.0-example.md`

## 3. Confirm CI on `main`

In GitHub:
- verify the latest `ci.yml` run is green
- confirm artifacts were uploaded
- confirm checksum files were generated

## 4. Create the tag

```powershell
git checkout main
git pull
git tag v1.0.0
git push origin v1.0.0
```

Expected outcome:
- `release.yml` starts automatically
- packaging uses normalized version `1.0.0`

## 5. Verify the GitHub Release

Confirm that the release includes:
- versioned zip artifact
- matching `.sha256`
- rolling latest package zip
- release notes

## 6. Validate deploy path with dry run

Run `deploy-sim.yml` with:
- target artifact from CI
- `dry_run=true`

Expected outcome:
- artifact and package resolve correctly
- checksum resolves correctly
- no files are copied

## 7. Execute sim deployment

Run `deploy-sim.yml` with:
- same artifact
- `dry_run=false`

Then run `post-deploy-verify.yml` if desired.

Expected outcome:
- package copied to sim folder
- checksum copied and validated
- health check passes

## 8. Validate promotion path with dry run

Run `promote.yml` with:
- same artifact
- `dry_run=true`

Expected outcome:
- approval path works
- validated target path resolves
- no files are copied

## 9. Execute validated promotion

Run `promote.yml` with:
- same artifact
- `dry_run=false`

Expected outcome:
- package copied to validated drop folder
- checksum validated
- post-promotion health check passes

## 10. If something fails

Use:
- `docs/workflow-troubleshooting-matrix.md`
- `docs/promotion-rollback-incident-runbook.md`
- `docs/rollback.md`

If needed, run `rollback.yml` in `dry_run=true` mode first, then perform the actual rollback.

## 11. Close out the release

- finalize release notes
- record any operator findings
- confirm rollback artifact availability
- update planning items for the next release or hotfix
