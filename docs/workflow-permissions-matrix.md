# Workflow Permissions Matrix

This matrix summarizes the expected permission posture and operational access requirements for each workflow.

| Workflow | GitHub token posture | Environment / approval | Runner | External access / side effects |
| --- | --- | --- | --- | --- |
| `ci.yml` | read-only contents is usually sufficient | none | GitHub-hosted Windows | builds/tests/packages, uploads artifacts |
| `release.yml` | `contents: write` for GitHub Release creation | none | GitHub-hosted Windows | creates GitHub Release and uploads release assets |
| `codeql.yml` | `security-events: write` | none | GitHub-hosted Windows | uploads CodeQL analysis results |
| `deploy-sim.yml` | minimal read permissions | optional `sim` environment if used | self-hosted Windows `nt8` | copies package/checksum to sim drop folder |
| `promote.yml` | minimal read permissions | `validated` reviewers recommended | self-hosted Windows `nt8` | copies package/checksum to validated drop folder |
| `rollback.yml` | minimal read permissions | align with validated rollback policy | self-hosted Windows `nt8` | re-deploys prior package to sim/validated lane |
| `post-deploy-verify.yml` | minimal read permissions | optional environment gate | self-hosted Windows `nt8` | runs health/checksum verification only |
| `promote-production.yml` | minimal read permissions | `production` reviewers expected | self-hosted Windows `nt8` | copies package/checksum to production drop folder |
| `rollback-production.yml` | minimal read permissions | `production` reviewers expected | self-hosted Windows `nt8` | re-deploys prior known-good production package |
| `_build-package.yml` | inherits caller permissions | inherits caller context | GitHub-hosted Windows | shared build/package/checksum logic |
| `_deploy-package.yml` | inherits caller permissions | inherits caller context | self-hosted Windows `nt8` | shared resolution/copy/verify logic |

## Guidance

- Default repository Actions permissions to the lowest practical setting.
- Elevate permissions only for workflows that need them.
- Limit manual dispatch access for deploy, promote, and rollback workflows to trusted maintainers.
- Prefer environment protection for `validated` and `production` workflows.
- Treat reusable workflow changes as privileged operational changes.
