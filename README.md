# AI381 Lab 4 — Local Terraform + Docker

This independent repository implements AI381 Lab 4 locally with instructor
approval. Terraform manages the Customer Churn FastAPI container in Docker
Desktop through WSL2. No Azure resources or credentials are used.

## Architecture

- Provider: `kreuzwerker/docker` pinned to `4.7.0`.
- Image: existing `ai381-lab4-churn:test`, tagged from `ai381-lab3-champion:test`.
- Container: `ai381-lab4-churn-api`, separate from Lab 2/3 containers.
- Access: `http://127.0.0.1:8000`, mapped to container port 8000.
- Ownership: `owner`, `course`, `lab`, and `managed_by` labels.
- State: local to `infra/`; state, plans, and local variables stay outside Git.

`infra/.terraform.lock.hcl` is committed to preserve provider selection and checksums.
The original Azure starter is kept locally, unchanged and excluded from Git.

## Setup

Use WSL2 with Terraform 1.17.2 and Docker Desktop WSL integration enabled.
The existing image must already be present. This repository does not build it.

```bash
docker image inspect ai381-lab4-churn:test
cd infra
cp terraform.tfvars.example terraform.tfvars
# Adjust ownership, image/tag, container name, and published port as needed.
terraform init -lockfile=readonly
terraform fmt -check
terraform validate
```

Copy the example only when a local variable file does not already exist.
The image must start FastAPI on `0.0.0.0:8000`. Confirm the published port is
available and the container name is unused before the first deployment.

## Deploy and verify

Run all Terraform commands from `infra/`:

```bash
terraform plan -out=lab4.tfplan
terraform show lab4.tfplan
# Review: first deployment should add 2 resources, change 0, destroy 0.
terraform apply lab4.tfplan
terraform output
docker ps --filter name=ai381-lab4-churn-api
curl --fail http://127.0.0.1:8000/health
curl --fail http://127.0.0.1:8000/openapi.json
curl --fail -H 'Content-Type: application/json' \
  --data '{"tenure_months":12,"monthly_fee":65.5,"support_calls":2,"contract":"Month-to-month","internet_service":"Fiber optic"}' \
  http://127.0.0.1:8000/predict
```

The verified deployment returned `{"status":"ok"}` from `/health` and
`{"churn_probability":0.288}` for that prediction request. Docker reported healthy.
Use the configured published port if it differs from 8000.

## CI and local limitations

Pull requests and pushes to `main` run formatting, initialization without the
state backend, validation, and a Trivy configuration scan. HIGH or CRITICAL
findings fail CI. Action references are pinned to full upstream commit SHAs;
Terraform and Trivy versions are pinned too. This scans infrastructure
configuration, not the application image or its dependencies. Trivy coverage
depends on its supported Docker resource policies.

Deployment remains a manual local action. GitHub-hosted runners cannot access
the WSL Docker Desktop daemon or local state, so CI has no plan/apply job,
Azure OIDC, cloud credentials, or deployment secrets. Runtime checks use the
local API after deployment.

Docker labels replace Azure tags. This setup does not reproduce Azure Log
Analytics, managed Container Apps environments, autoscaling/scale-to-zero,
managed revisions, public HTTPS ingress, Azure budget alerts, or shared Azure
state storage. Local state is not a team remote backend; keep it backed up
privately and do not run concurrent deployments from different state copies.

## Verified Lab 4 results

Results below were recorded on 26 November 2026. They describe completed
demonstrations, not a fresh runtime test during documentation preparation.

| Demonstration | Verified result |
|---|---|
| Initial deployment | 2 added, 0 changed, 0 destroyed; health and prediction requests returned HTTP 200 |
| [PR #1](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/pull/1) | Reviewed restart policy change to `unless-stopped`; merged with commit `63e1fc20a30197febecbf252bd1100f7a9c1645c` |
| [PR CI run](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/actions/runs/45820246862) | Formatting, initialization, validation, and Trivy configuration scanning passed |
| Controlled drift | Manual restart policy `no`; plan detected exactly 0 additions, 1 in-place correction, 0 destructions |
| Drift recovery | Apply: 0 added, 1 changed, 0 destroyed; same container ID; final plan had no changes |
| Controlled destroy | Exactly 2 Lab 4 Terraform resource records removed; both image tags retained |
| Timed rebuild | Apply: 2 added, 0 changed, 0 destroyed, in **3.332850438 seconds** |
| Post-rebuild verification | New container running and healthy, restart policy `unless-stopped`, `/health` HTTP 200, final plan with no changes |

Rebuild timing uses `time.monotonic_ns()` around the whole Terraform apply
process, including planning and creation. It excludes subsequent health
verification and reuses the local image without rebuilding it. See the
[evidence index](evidence/README.md) for command output, safety checks, timing,
container identity checks, and submission gaps.

The local requirements demonstrated are declarative image/container management,
variable inputs, ownership labels, a localhost URL output, provider locking,
PR checks, manual local deployment, drift recovery, and a timed rebuild.
Azure OIDC, remote state, Azure cost controls, and automatic GitHub-hosted apply
are **not implemented**. The GitHub workflow neither posts Terraform plan
comments nor performs an automatic deployed-API smoke test; plans and runtime
tests were executed locally. Instructor approval covers the local deployment
and independent repository; equivalence to each grading item must still be
checked against the e-learning rubric.

## Final submission audit

For the final technical audit, remaining submission checks, and URL file, see
[SUBMISSION_CHECKLIST.md](SUBMISSION_CHECKLIST.md) and [repo.txt](repo.txt).
The [fresh API evidence](evidence/api-audit-20261126-185623/) confirms a healthy
container and HTTP 200 from both `/health` and the schema-valid `/predict`
request (`churn_probability: 0.288`). No deployment changes were made during
that audit.

## Cleanup

When you intentionally want to remove the Lab 4 deployment, review a destroy
plan from `infra/` and then apply that reviewed plan:

```bash
terraform plan -destroy -out=cleanup.tfplan
terraform show cleanup.tfplan
terraform apply cleanup.tfplan
```

This removes the Terraform-managed Lab 4 container. `keep_locally = true`
preserves the Docker image. Never import Lab 2/3 containers into this state or
delete state files as a substitute for cleanup. Cleanup commands are provided
for later use; preparing this repository does not execute them.
