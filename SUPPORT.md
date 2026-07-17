# Support

## How to get help

Use the following path depending on the type of question:

### 1. Documentation first
Start with:
- `README.md`
- `docs/README.md`
- `docs/faq.md`
- `docs/workflow-troubleshooting-matrix.md`
- `docs/promotion-rollback-incident-runbook.md`

### 2. Questions and setup help
If GitHub Discussions is enabled for the repository, use Discussions for:
- setup questions
- workflow usage questions
- runner maintenance questions
- release process clarification

If Discussions is not enabled, open an issue using the most relevant issue template.

### 3. Bug reports
Open an issue when:
- a workflow fails unexpectedly
- documentation is incorrect or incomplete
- a deployment, promotion, or rollback flow behaves differently than documented
- checksum, artifact resolution, or runner behavior appears broken

Include:
- workflow name
- run URL or run number
- exact error message
- whether `dry_run` was used
- target environment (`sim`, `validated`, or `production`)
- relevant artifact/package name

### 4. Security issues
Do not post sensitive details in a public issue.
See `SECURITY.md` for security reporting guidance.

## Before opening a support request
Collect these first:
- workflow name and run link
- package name/version
- target environment
- whether checksum verification was enabled
- whether the problem reproduces in `dry_run`
- relevant runner/log folder details

## Maintainer support checklist
When responding to a support request:
1. classify the issue as setup, workflow bug, runner issue, or documentation gap
2. point the user to the closest existing doc/runbook
3. request the exact workflow inputs and artifact name
4. determine whether rollback or dry-run validation is the safest next step
5. capture any missing documentation follow-up
