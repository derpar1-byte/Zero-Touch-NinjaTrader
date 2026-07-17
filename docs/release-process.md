# Release Process

This repository uses lightweight semantic versioning with Git tags to drive release packaging and GitHub Releases.

## Versioning rules

- Tag format: `vMAJOR.MINOR.PATCH`
- Examples:
  - `v1.0.0`
  - `v1.1.0`
  - `v1.1.1`
- The release workflow normalizes the tag by removing the leading `v` before packaging.
  - `v1.2.3` becomes package version `1.2.3`

## Recommended meaning

- `MAJOR`: breaking workflow, packaging, or deployment contract changes
- `MINOR`: backward-compatible additions such as new workflows, validations, or packaging features
- `PATCH`: fixes, documentation corrections, or non-breaking hardening updates

## Release flow

1. Merge approved changes into `main`.
2. Verify `ci.yml` is green.
3. Update `CHANGELOG.md` under `Unreleased`.
4. Create and push a version tag.
5. `release.yml` runs automatically.
6. GitHub Release is created with packaged artifacts and checksum files.

## Tag examples

Create and push `v1.0.0`:

```powershell
git tag v1.0.0
git push origin v1.0.0
```

Create and push `v1.1.0`:

```powershell
git tag v1.1.0
git push origin v1.1.0
```

## Expected release artifacts

A successful tag release should publish:
- versioned export zip
- matching `.sha256` checksum file
- rolling latest zip
- GitHub Release entry for the tag

## Pre-release checklist

- `dotnet restore .\ZeroTouchNinjaTrader.sln`
- `dotnet build .\ZeroTouchNinjaTrader.sln -c Release`
- `dotnet test .\ZeroTouchNinjaTrader.sln -c Release`
- `CHANGELOG.md` updated
- deploy/promote workflows reviewed if delivery behavior changed

## Notes

- Prefer tags on commits already merged to `main`.
- Avoid reusing or moving release tags.
- If a release is bad, publish a new patch tag instead of rewriting history.
