# Contributing

Thanks for contributing to Zero-Touch-NinjaTrader.

## Development workflow

1. Create a branch from `main`.
2. Make focused changes.
3. Validate locally:
   ```powershell
   dotnet restore .\ZeroTouchNinjaTrader.sln
   dotnet build .\ZeroTouchNinjaTrader.sln -c Release
   dotnet test .\ZeroTouchNinjaTrader.sln -c Release
   ```
4. Open a pull request using the repository PR template.
5. Wait for CI to pass before merging.

## Change guidelines

- Keep changes small and reviewable.
- Update `README.md` when workflow, setup, or operator behavior changes.
- Update `CHANGELOG.md` for notable user-facing changes.
- Keep packaging, deploy, and promotion scripts aligned with workflow YAML.
- Prefer PowerShell and .NET 8-compatible changes for runner automation.

## Workflow-specific expectations

### CI and packaging

When changing:
- `.github/workflows/ci.yml`
- `deploy/package-nt8.ps1`
- `src/Common/appsettings.json`

also verify that:
- artifact names still match deploy/promote expectations
- checksum generation still works
- README examples remain accurate

### Deployment and promotion

When changing:
- `.github/workflows/deploy-sim.yml`
- `.github/workflows/promote.yml`
- `deploy/deploy-sim.ps1`
- `deploy/health-check.ps1`
- workflow permissions or environment usage

also verify that:
- self-hosted runner labels are still correct
- GitHub Environment usage is still correct
- checksum validation behavior remains consistent
- log output is still usable for operators
- the workflow token permissions are still minimal for the task

## Code review

`CODEOWNERS` defines the default review ownership for this repository.

If branch protection is enabled, expect:
- pull request review
- passing status checks
- resolved review conversations

## Reporting issues

Use the issue templates for:
- bug reports
- feature requests

For setup or workflow questions, use repository discussions if enabled.
