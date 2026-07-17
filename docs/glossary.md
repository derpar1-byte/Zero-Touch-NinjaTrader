# Glossary

## Artifact bundle
The uploaded GitHub Actions artifact that contains packaged zip files and related outputs from CI or release workflows.

## Checksum
A SHA-256 hash file (`.sha256`) used to verify that a package zip file has not changed unexpectedly.

## Cutover
The controlled transition from a previously active package/version to a newly approved one.

## Dry run
A workflow mode that resolves artifacts, packages, and target paths without copying files to the destination folder.

## Environment
A GitHub Environment used to apply approvals, reviewers, and deployment controls such as `validated` or `production`.

## Known-good artifact
A previously validated package that is safe to redeploy during rollback.

## Package
A NinjaTrader-oriented zip file produced by the packaging workflow for deployment/import.

## Post-deploy verification
The automated or manual validation performed after deploy, promote, or rollback to confirm package integrity and expected system state.

## Promotion
The controlled movement of a package from one trust level to another, such as sim to validated or validated to production.

## Release tag
A git tag like `v1.0.0` that triggers release automation and is normalized to a semantic package version like `1.0.0`.

## Reusable workflow
A GitHub Actions workflow invoked by another workflow to centralize shared logic, such as `_build-package.yml` or `_deploy-package.yml`.

## Rollback
Redeploying a previous known-good package after a failed deploy, failed promotion, or post-deploy issue.

## Runner
The machine executing a GitHub Actions job. In this repo, deployment workflows expect a Windows self-hosted runner with the `nt8` label.

## Validated
The approval-gated intermediate environment used before future production promotion.
