# Lab 4 evidence

Recorded on 26 November 2026 (Amman time). These files document completed local
demonstrations; they are not Terraform state files or executable saved plans.

## Controlled drift and recovery

Folder: [drift-20261126-183953/](drift-20261126-183953/).

1. Container was running and healthy with `restart=unless-stopped`; baseline
   plan had no changes (`01-before.json`, `02-baseline-plan.txt`).
2. Only `docker update --restart=no ai381-lab4-churn-api` was run manually.
   Terraform code still declared `unless-stopped` (`03-manual-drift.json`).
3. Plan detected exactly **0 to add, 1 in-place change, 0 to destroy**.
   JSON inspection confirmed only the restart policy correction and no
   replacement (`04-drift-plan.txt`, `05-plan-safety-check.json`).
4. Recovery apply completed **0 added, 1 changed, 0 destroyed**
   (`06-recovery-apply.txt`).
5. `/health` returned HTTP 200 with `{"status":"ok"}`; final plan had no changes.
   Container ID stayed unchanged and Docker reported healthy
   (`07-final-health.txt`, `08-final-plan.txt`, `09-after-summary.json`).

With `-detailed-exitcode`, exit code 2 means a successful plan with changes;
exit code 0 means no changes. The drift plan's exit code 2 is expected.

## Controlled destroy and timed rebuild

Folder: [rebuild-20261126-184433/](rebuild-20261126-184433/).

| Evidence | Result |
|---|---|
| `01-before.json` | Only `docker_image.api` and `docker_container.api` managed; healthy API, image tags and original container ID recorded |
| `02-destroy-plan.txt`, `03-destroy-safety-check.json` | Only the two Lab 4 resource records targeted; `keep_locally=true` |
| `04-destroy.txt` | Terraform reported 2 resources destroyed |
| `05-post-destroy-check.json` | Lab 4 container removed; Lab 4 and original Lab 3 image tags retained with unchanged image IDs; other containers unchanged |
| `06-timed-rebuild-apply.txt` | Existing image reused; 2 added, 0 changed, 0 destroyed |
| `07-rebuild-timing.json` | Exact apply duration **3.332850438 seconds**, or 3,332,850,438 monotonic nanoseconds |
| `08-final-health.txt` | `/health`: HTTP 200, `{"status":"ok"}` |
| `09-final-plan.txt` | No changes, exit code 0 |
| `10-after-summary.json` | New container ID, healthy/running status, retained image IDs, `unless-stopped`, final results |

The timer surrounds the entire `terraform apply` process, including planning
and creation. It excludes later health checks. This is an infrastructure
rebuild from a retained image, not a Docker image build. Destroying the image
resource record did not delete the Docker image because `keep_locally=true`.

Before container: `26b5872cc00508382fd4f48bb3862a05144247912b4ce8c1d59edb7c3b3c951c`.
After container: `e0d66327e1d3062f4d0c6817180e7ebcc67abf979f39e3122c3bb37347cd0279`.

## PR and CI

[PR #1](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/pull/1)
changed the restart policy and was merged using merge commit
`63e1fc20a30197febecbf252bd1100f7a9c1645c`.
The [PR CI run](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/actions/runs/45820246862)
passed formatting, initialization, validation, and Trivy configuration checks.
Plans and deployments ran locally; there is no Azure OIDC, shared remote
state, Azure budget enforcement, or automatic GitHub-hosted apply. Trivy's
configuration scan is not an application image vulnerability scan.

## Fresh API submission audit

Folder: [api-audit-20261126-185623/](api-audit-20261126-185623/).
`01-container.json` records selected non-sensitive fields: the rebuilt container
is running and healthy with restart policy `unless-stopped`.
`02-openapi.json` captures the public API schema used to validate the synthetic
request. `03-health.json` records GET `/health`: HTTP 200, `{"status":"ok"}`.
`04-predict.json` records the synthetic request and POST `/predict`: HTTP 200,
`{"churn_probability":0.288}`. No Docker configuration was changed.

## Public evidence review

All 23 captured evidence files were reviewed before staging. Public copies
omit unrelated container inventory, runtime bridge addresses, MAC address,
and runtime hostname. Redacted log sections are marked explicitly. Lab 4
container/image IDs, generic application paths, localhost URLs, and timing
are retained to support verification. No state dumps, saved plan binaries,
credentials, local variable files, or private host paths are included.

The following still need submission review:

- Obtain the full e-learning rubric and check required artifacts, filenames,
  video length, and submission format. It is not available in this repository.
- Attach the instructor's approval for the local deployment and separate
  repository if the submission requires written proof.
- No screenshots or recorded video are included. If required, capture PR/CI,
  drift detection/recovery, timed rebuild results, and healthy API evidence.
  Do not repeat destructive demonstrations merely to produce screenshots.
- Standalone prediction request/response and OpenAPI evidence are now included
  in the fresh API audit folder above; this previous evidence gap is closed.
- Confirm grading acceptance for omitted Azure features, automated PR plan
  comments, and automatic post-deployment smoke testing; local logs demonstrate
  the corresponding manual checks where applicable.

No claim is made that screenshots, video, or every rubric item is complete.
See the [final submission checklist](../SUBMISSION_CHECKLIST.md) for the full
audit scope and known differences from the Azure starter.
