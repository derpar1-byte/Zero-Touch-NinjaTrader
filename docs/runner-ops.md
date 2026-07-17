# Runner Operations Playbook

This document covers practical care and feeding of the Windows self-hosted runner used for NinjaTrader deployment workflows.

## Goals

- Keep deployment runs predictable
- Minimize runner drift
- Reduce risk from stale tools, stale workspaces, or interrupted jobs
- Provide a repeatable validation path after maintenance

## Baseline software

Install and keep current:
- Windows updates appropriate for your runner policy
- .NET 8 SDK
- .NET 8 runtime
- PowerShell 7+
- GitHub Actions self-hosted runner service
- NinjaTrader 8

Verify periodically:

```powershell
dotnet --info
dotnet --list-sdks
dotnet --list-runtimes
pwsh --version
where.exe dotnet
```

## Required runner labels

The deployment runner should include:
- `self-hosted`
- `windows`
- `nt8`

## Recommended folders

```text
C:\NinjaTraderDeploy\Import
C:\NinjaTraderDeploy\Validated
C:\NinjaTraderDeploy\Logs
C:\NinjaTraderDeploy\Staging
C:\NinjaTraderDeploy\Exports
```

## Routine checks

### Daily or before important promotions
- confirm the runner is online in GitHub
- confirm disk space is healthy
- confirm NinjaTrader-related folders still exist
- confirm `dotnet --info` still reports the expected .NET 8 SDK/runtime
- confirm no unexpected long-running NinjaTrader or runner processes are stuck

### After Windows updates or tool changes
- rerun `dotnet --info`
- rerun a dry-run deployment from GitHub Actions
- rerun a real sim deployment before promoting anything important

## Dry-run validation

Use `deploy-sim.yml` or `promote.yml` with `dry_run = true` to verify:
- runner targeting
- artifact resolution
- checksum discovery
- environment variable wiring

This should be your first step after provisioning or maintaining a runner.

## Log review

Check `NT8_LOG_FOLDER` for:
- recent deployment entries
- repeated checksum failures
- repeated missing artifact or folder errors
- unusual gaps in deployment history

## Common operational issues

### Runner online but jobs do not pick it up
- verify labels match workflow expectations exactly
- confirm the runner belongs to the correct repository or runner group
- check whether the runner service is actually running

### Deployment job starts but cannot access folders
- verify GitHub Actions variables are correct
- verify service account permissions on drop/log folders
- verify antivirus or endpoint controls are not blocking writes

### Build/test suddenly fail on the runner
- recheck .NET 8 SDK/runtime presence
- confirm `global.json` still matches an installed SDK
- confirm PATH still resolves the intended `dotnet`

### Checksum mismatches
- confirm the matching `.sha256` came from the same artifact bundle
- rerun CI packaging for a clean artifact set
- inspect whether files were modified after packaging

## Service maintenance

If the runner becomes unhealthy:
1. stop accepting new jobs
2. let active work finish or cancel intentionally
3. restart the runner service
4. rerun a dry-run deployment
5. rerun a sim deployment
6. only then allow promotion use again

## Security practices

- use least privilege for the runner service account
- avoid interactive browsing or unrelated software on the runner
- keep deployment folders scoped to the repo’s operational needs
- review workflow changes through pull requests
- prefer environment protections for promotion workflows

## Recovery checklist

After a runner interruption or rebuild:
1. verify runner registration and labels
2. verify .NET 8 SDK/runtime availability
3. verify PowerShell availability
4. verify GitHub Actions variables still point to valid folders
5. run `deploy-sim.yml` with `dry_run = true`
6. run a real sim deployment
7. run a validated promotion only after sim succeeds
