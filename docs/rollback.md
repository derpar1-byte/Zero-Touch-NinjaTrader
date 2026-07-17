# Rollback Guide

This document describes how to revert to a previously known-good package using the repository’s deployment workflows.

## Principles

- Prefer rollback by redeploying a previously validated package
- Do not rewrite history or move release tags
- Use checksum-backed artifacts when available
- Start with a dry run if the target runner was recently changed

## When to rollback

Consider rollback when:
- a newly deployed package fails post-deploy checks
- runtime behavior is degraded after promotion
- operational validation fails in sim or validated environments
- package integrity is in doubt and a known-good prior artifact exists

## Safe rollback flow

1. Identify the last known-good artifact.
2. Confirm the matching checksum file exists when available.
3. Run `rollback.yml` with `dry_run = true`.
4. Verify the workflow resolves the expected package and checksum.
5. Run `rollback.yml` again with `dry_run = false`.
6. Confirm logs and health checks pass.
7. Document the rollback in release notes or incident tracking.

## Artifact selection

Use one of these sources:
- a prior CI artifact bundle
- a prior GitHub Release asset set
- a previously validated package retained in your operational storage

The safest rollback target is the most recent package that was proven good in the same environment.

## Example rollback procedure

Rollback to a known package file:

```text
artifact_name: zerotouch-package
package_file: ZeroTouchNinjaTrader-SampleStrategy-1.0.1-20250101-120000.zip
dry_run: true
```

If the dry run resolves the expected package, rerun with:

```text
dry_run: false
```

## Post-rollback checks

- verify deployment logs were written
- verify checksum validation passed when applicable
- verify the drop folder contains the intended package
- verify any environment-specific smoke checks pass
- create a follow-up fix instead of repeatedly toggling between versions

## Notes

- Keep prior artifacts long enough to support rollback needs.
- Prefer small patch releases after rollback to restore forward progress cleanly.
