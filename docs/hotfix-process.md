# Hotfix process

This document describes how to ship an urgent fix outside the normal feature cadence while preserving validation, approval, and rollback discipline.

## When to use the hotfix path

Use a hotfix when all of the following are true:
- the issue materially impacts trading, deployment, validation, or recovery
- waiting for the next planned release is not acceptable
- the fix can be scoped narrowly and verified quickly

Examples:
- packaging produces an invalid archive
- deployment checksum verification fails due to a known workflow bug
- a strategy artifact must be reverted or patched urgently

## Hotfix principles

- keep the change set minimal
- prefer fixing on top of the latest known-good `main`
- preserve CI, deploy, promotion, and rollback checks
- create explicit release notes and rollback guidance
- tag the hotfix with a semantic patch version

## Suggested flow

1. Create a hotfix branch from `main`.
2. Implement the smallest safe fix.
3. Update `CHANGELOG.md` and relevant docs.
4. Run local validation:
   - `dotnet restore .\ZeroTouchNinjaTrader.sln`
   - `dotnet build .\ZeroTouchNinjaTrader.sln -c Release`
   - `dotnet test .\ZeroTouchNinjaTrader.sln -c Release`
5. Open a pull request and request expedited review.
6. Merge to `main` once CI is green.
7. Create a hotfix tag such as `v1.0.1`.
8. Verify `release.yml` publishes the artifact and checksum.
9. Run `deploy-sim.yml` first, preferably with `dry_run=true` if artifact selection changed.
10. Run `promote.yml` after approval.
11. Run `post-deploy-verify.yml`.
12. Keep `rollback.yml` ready with the previous known-good package.

## Versioning examples

- normal release after `v1.0.0`: `v1.1.0`
- hotfix for `v1.1.0`: `v1.1.1`
- second hotfix for that line: `v1.1.2`

## Checklist

Before tagging:
- root cause understood well enough to justify urgency
- release-readiness issue updated
- rollback target identified
- checksum workflow unchanged or revalidated
- runner availability confirmed

After promotion:
- logs reviewed
- checksum verification confirmed
- operator notes captured in release notes or issue
- follow-up work identified for the normal release path
