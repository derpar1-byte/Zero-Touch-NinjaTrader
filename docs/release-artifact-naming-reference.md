# Release Artifact Naming Reference

This page documents the expected naming patterns for packaged outputs and related files.

## Versioned export package
Pattern:

```text
artifacts/exports/<package>-<strategy>-<version>-<timestamp>.zip
```

Example:

```text
artifacts/exports/ZeroTouchNinjaTrader-SampleStrategy-1.0.0-20250101-153000.zip
```

Purpose:
- immutable build output for CI/release consumption
- preferred source for traceable deploy, promote, and rollback activity

## Export checksum
Pattern:

```text
artifacts/exports/<package>-<strategy>-<version>-<timestamp>.zip.sha256
```

Example:

```text
artifacts/exports/ZeroTouchNinjaTrader-SampleStrategy-1.0.0-20250101-153000.zip.sha256
```

Purpose:
- verifies the matching versioned export package
- used during deployment and post-deploy validation when checksum enforcement is enabled

## Rolling latest package
Pattern:

```text
artifacts/packages/<package>-<strategy>-latest.zip
```

Example:

```text
artifacts/packages/ZeroTouchNinjaTrader-SampleStrategy-latest.zip
```

Purpose:
- convenience pointer to the newest package
- useful for sim or early validation flows
- less explicit than versioned artifacts, so production-oriented flows should prefer versioned packages when possible

## Tag normalization
Release tags are expected in this format:

```text
v1.0.0
```

Release packaging normalizes that to:

```text
1.0.0
```

That normalized semantic version is what should appear inside package naming.

## Recommended operator preference
Use this order of preference when selecting packages:
1. exact versioned package
2. exact known-good package for rollback
3. `latest` package only for lower-risk or early validation use cases

## Related references
- `release-process.md`
- `first-release-v1.0.0-walkthrough.md`
- `workflow-troubleshooting-matrix.md`
