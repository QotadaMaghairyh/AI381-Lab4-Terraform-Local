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
