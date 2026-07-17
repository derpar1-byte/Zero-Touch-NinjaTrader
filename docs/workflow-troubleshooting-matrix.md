# Workflow Troubleshooting Matrix

Use this matrix when a workflow fails and you need a quick symptom-to-action lookup.

| Symptom | Likely area | Common causes | Immediate checks | Likely next action |
| --- | --- | --- | --- | --- |
| CI fails during restore | .NET/NuGet | missing SDK, package resolution issue, bad solution/project reference | inspect restore logs, verify `global.json`, run `dotnet restore` locally | fix SDK/project/package issue and rerun CI |
| CI fails during build | source/build config | compile error, invalid project settings, missing file | inspect compile error, run `dotnet build -c Release` locally | fix code or project config |
| CI fails during test | test/runtime | missing runtime, broken tests, invalid test references | inspect test output, run `dotnet test -c Release` locally | fix test/runtime issue |
| Package step fails | packaging script | bad source path, invalid version input, zip/write permission issue | inspect `package-nt8.ps1` output, verify artifact directories | fix script inputs or packaging layout |
| Release workflow fails on tag | tagging/release | malformed tag, permissions, artifact mismatch | verify tag format like `v1.0.0`, check release job permissions | correct tag or workflow permissions |
| Deploy/promotion workflow cannot find artifact | artifact selection | wrong artifact name, artifact expired, workflow mismatch | verify artifact name from CI run, confirm artifacts exist | rerun CI or select correct artifact |
| Deploy/promotion workflow cannot find package file | package resolution | wrong `package_file`, unexpected package name, missing latest zip | inspect downloaded artifact contents | supply exact package file or fix package naming |
| Checksum file missing | packaging/integrity | checksum not uploaded, wrong artifact bundle, manual file deletion | verify `.sha256` exists in CI artifacts | rerun CI/package or use correct artifact |
| Checksum mismatch | integrity/deploy path | corrupted artifact, stale file, wrong checksum matched | compare package and checksum names, inspect deploy log | stop promotion, fetch correct artifact, consider rollback |
| Dry run passes but live deploy fails | file system/runner | folder permissions, path typo, runner service account issue | verify target folders exist and runner account can write | fix folder/permission issue and rerun |
| Health check fails after deploy | target environment | missing copied files, missing logs, checksum mismatch | run `post-deploy-verify.yml`, inspect drop/log folders | correct deployment issue or rollback |
| Approval gate not triggered | GitHub environment | workflow not targeting environment, no reviewers configured | inspect workflow environment, check GitHub environment settings | configure reviewers/environment correctly |
| Workflow stuck waiting for runner | runner | runner offline, missing labels, service stopped | inspect runner status in GitHub, verify labels `self-hosted`, `windows`, `nt8` | start/fix runner or label config |
| Production promotion should not continue | ops/release control | failed validation, unapproved cutover, unresolved incident | halt workflow, review cutover checklist and incident state | stop, investigate, or rollback |
| Rollback fails to resolve prior artifact | rollback inputs | package file not specified, artifact missing, wrong environment target | verify previous known-good artifact and exact package file | rerun with correct artifact/package selection |

## Escalation guide

If the failure affects validated or production promotion:
1. stop further manual promotions
2. preserve logs and workflow links
3. run dry-run validation to isolate resolution problems
4. use `docs/promotion-rollback-incident-runbook.md`
5. execute rollback only after confirming the prior known-good artifact

## Useful companion docs
- `promotion-rollback-incident-runbook.md`
- `rollback.md`
- `runner-ops.md`
- `post-deploy-checklist.md`
- `release-cutover-checklist.md`
