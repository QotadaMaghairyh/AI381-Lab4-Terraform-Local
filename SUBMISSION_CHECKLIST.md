# AI381 Lab 4 final submission audit

Audit date: 26 November 2026 (Amman time).
Repository: <https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local>.
The instructor approved local deployment and an independent repository,
as confirmed by the student. [repo.txt](repo.txt) contains only the repository URL.

## Sources and limits

Reviewed local starter materials: `AI381_Lab4_Starter_Module/README.md`,
`infra/main.tf`, and `.github/workflows/terraform.yml` inside that starter.
These describe Azure resources, workflow TODOs, drift, and a timed rebuild.
The starter README explicitly places the full instructions, checkpoints,
and rubric on the Lab 4 e-learning page. No separate full instructions or
rubric were found in the workspace; they were not accessed on e-learning.
The original starter remains unchanged and excluded from Git.

This is a technical readiness checklist, not a claim that every grading
criterion is met. No required video duration, screenshot count, deadline,
grading weight, or submission packaging rule can be verified locally.

## Completed for the approved local implementation

- [x] Independent public repository, Terraform source, input examples,
  provider lock file, setup/deployment/cleanup documentation, and URL file.
- [x] Docker provider 4.7.0; local state; existing image reused; ownership
  labels, variable inputs, localhost application URL, and image retention.
- [x] [PR #1](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/pull/1)
  merged through a merge commit; [PR CI](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/actions/runs/45820246862)
  passed formatting, initialization, validation, and Trivy configuration checks.
  Workflow action references are full commit SHAs.
- [x] Controlled restart-policy drift detected: 0 additions, 1 in-place
  correction, 0 destructions. Recovery applied; final plan had no changes.
- [x] Controlled destroy removed only the two Lab 4 Terraform records;
  Lab 4 and original Lab 3 image tags were retained. Rebuild added two
  resources in **3.332850438 seconds** using a monotonic timer.
- [x] Post-rebuild plan had no changes. This final audit did not rerun
  Terraform plan/apply/destroy; it reviewed the recorded plan evidence.
- [x] Fresh audit: existing container running/healthy, restart policy
  `unless-stopped`; GET `/health` HTTP 200, `{"status":"ok"}`.
- [x] Fresh audit: current OpenAPI schema checked; synthetic POST `/predict`
  HTTP 200, `{"churn_probability":0.288}`. Request and schema are saved.
- [x] Public evidence reviewed for credentials, private host paths,
  state dumps, and unrelated environment information before staging.

## Partial equivalents and known differences

| Starter behavior | Local implementation / remaining difference |
|---|---|
| PR pipeline with plan comment | Format/init/validate/Trivy pass; plans run locally and are not posted automatically as PR comments |
| Merge-triggered apply and `/health` smoke test | Manual local apply and API verification completed; no automatic GitHub-hosted deployment or runtime smoke-test job |
| Azure ingress and liveness probe | Localhost port 8000 and image-provided Docker health check; no public managed HTTPS ingress |
| Container template sizing | Starter's explicit 0.5 CPU / 1 GiB limits are not configured in local Terraform |
| CI-built short-SHA image tag | Existing local `test` tag is used; image ID is recorded in evidence, but an immutable CI-built deployment tag is not configured |
| Security scan | Terraform configuration scanned; application-image vulnerability scanning and full Docker policy coverage are not demonstrated |

## Azure-specific functionality not implemented

- Azure resource group, Log Analytics workspace, Container Apps environment,
  managed revisions, autoscaling, and scale-to-zero.
- Azure/Entra OIDC federation and Azure login from GitHub Actions.
- Azure Storage remote state and shared remote-state locking; state is local.
- Azure cost controls and budget alerts. The starter marks the budget as an
  **optional bonus**; the missing full rubric may add context.
- Automatic GitHub-hosted apply to the local Docker Desktop daemon.

These are declared scope differences, not hidden completed features.
Confirm their grading treatment against the instructor-approved adaptation
and the full rubric.

## Video, screenshots, and submission review

- [ ] Obtain and compare the full official e-learning rubric/instructions.
- [ ] Check exact upload format and whether `repo.txt` must be uploaded separately.
- [ ] Attach written approval if requested; no approval document is included.
- [ ] Check whether a video/screenshots are required. None were found locally
  or included in the repository; their mandatory status and length/count
  cannot be established from the available starter alone.
- [ ] If required, capture the repository/PR/green CI, architecture explanation,
  drift plan and recovery evidence, retained-image destroy/rebuild timing,
  final zero-change plan, and health/prediction results. These are suggested
  coverage topics, not invented official requirements. Existing logs can be
  shown without repeating destructive commands.

## Evidence index

- [Drift and recovery](evidence/drift-20261126-183953/).
- [Destroy and timed rebuild](evidence/rebuild-20261126-184433/).
- [Fresh API audit](evidence/api-audit-20261126-185623/): selected container
  status, current OpenAPI response, health response, and synthetic prediction.
- [Detailed evidence guide](evidence/README.md).

Known CI maintenance warning: pinned checkout/setup actions target Node.js 20;
GitHub ran them on Node.js 24 successfully. Updating those action pins is
future maintenance and was outside this documentation-only audit.
