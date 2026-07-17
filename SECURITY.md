# Security Policy

## Supported versions

This repository is currently pre-1.0 and maintained from the `main` branch.
Security fixes, if needed, will be applied to the latest state of `main`.

## Reporting a vulnerability

Please do not open public issues for suspected security vulnerabilities.

Instead:
1. gather the details needed to reproduce the issue
2. describe the potential impact
3. send the report privately to the repository owner through GitHub security reporting if enabled, or through a private contact channel

Include:
- affected workflow or script
- affected file paths
- reproduction steps
- logs or screenshots if relevant
- whether secrets, runner access, artifact integrity, or deployment paths are impacted

## Security areas to pay attention to

This repository includes CI/CD and self-hosted runner automation. Review changes carefully in these areas:
- `.github/workflows/`
- `deploy/`
- artifact download and checksum validation
- self-hosted runner labels and permissions
- GitHub Environment approvals
- filesystem paths used for import, staging, validation, and logs

## Hardening guidance

Recommended baseline practices:
- protect `main` with pull requests and required checks
- require reviewers for the `validated` environment
- keep the self-hosted runner dedicated to this workflow when possible
- restrict who can dispatch deployment and promotion workflows
- validate checksum files before moving deployment artifacts
- keep .NET and PowerShell updated on the runner machine
- avoid storing secrets directly in repository files
- prefer environment variables/secrets over hardcoded machine-specific values
- give workflows the minimum required token permissions
- review any change to `.github/workflows/` and `deploy/` as security-sensitive

## Workflow dispatch and permissions guidance

Recommended GitHub Actions posture for this repository:
- keep build/test workflows broadly runnable for normal collaboration
- restrict manual deploy and promote workflow dispatch to trusted operators
- use GitHub Environments to gate higher-risk workflows
- grant `contents: write` only to release workflows that need to publish releases
- avoid broad secret exposure to pull request workflows
- prefer environment-level scoping for deploy-related variables and secrets
