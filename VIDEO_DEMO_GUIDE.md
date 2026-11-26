# AI381 Lab 4 individual video guide

Target: **7 minutes 30 seconds**, within the requested 5–8 minutes. This is a
suggested recording sequence, not an official rubric specification. The full
e-learning rubric is not available locally.

Use the completed work and recorded evidence below. Say “recorded evidence”
when displaying logs; do not present those commands as a new live deployment.
The shell blocks use only `cd`, `git branch`, `git log`, `cat`, and `grep`.
`cd` changes the shell's working directory; the others display local data.
None invokes Terraform, Docker, or an API or modifies infrastructure.
Do not execute deployment, drift, cleanup, or rebuild commands from the logs.

Read only the **blockquote narration** aloud; tables, commands, JSON and other
paragraphs are screen directions/reference material. The narration is **567
words**: at 110–140 words per minute, plus 90–120 seconds for pointing at
results and switching prepared tabs, the estimate is **5:33–7:09**. The 7:30
timeline below includes extra margin. Rehearse once with a timer rather than
reading every filename or identifier; actual duration depends on delivery.

## Before recording

- Open the repository, PR, CI, and file tabs listed below; increase font size.
- Close private tabs and notifications. Do not display `.tfstate`, local
  `.tfvars`, saved plan binaries, credentials, or full environment dumps.
- Start a terminal in the workspace:

```bash
cd /home/qatada/AI381-Lab4-Terraform-Local
git branch --show-current
git log -1 --oneline
```

The audited revision is `d80abd8c54ccb381ecf806a2e05f72ca5042f0af`.
This guide is a subsequent uncommitted file; do not describe the working tree
as clean while it is untracked. Do not commit or push as part of recording.

## Suggested timeline

| Time | Screen | Main point |
|---|---|---|
| 0:00–0:35 | Repository and root README | Introduce yourself, Lab 4, instructor-approved local deployment and independent repository |
| 0:35–1:35 | Terraform files and `.gitignore` | Explain provider, state, image/container, variables, labels, localhost port, lock file and exclusions |
| 1:35–2:25 | README results and recorded container status | Explain actual deployment counts, outputs, restart policy and health |
| 2:25–3:15 | PR #1 and green CI | Show review change, merge commit, pinned workflow actions and passing checks |
| 3:15–4:15 | Drift evidence | Show baseline, manual restart-policy drift, in-place correction, recovery and zero-change result |
| 4:15–5:25 | Destroy/rebuild evidence | Show restricted destroy targets, retained images, new container ID and exact timing |
| 5:25–6:25 | API audit files | Show schema, synthetic prediction request, health and prediction HTTP 200 responses |
| 6:25–7:30 | Submission checklist and `repo.txt` | Explain local/Azure differences and remaining submission checks; conclude |

For a five-minute cut, shorten code browsing and show summary JSON plus the
plan/apply result lines. Keep the timing scope and implementation limits.
For an eight-minute version, spend the extra 30 seconds explaining the schema
and the retained-image safety check; no additional experiments are needed.

## 1. Introduction and architecture — 0:00–1:35

Open [the public repository](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local)
and [README.md](README.md).

> I implemented AI381 Lab 4 using Terraform and Docker Desktop through WSL2.
> The instructor approved local deployment instead of Azure and an independent
> repository. This recording reviews completed experiments and committed
> evidence; I am not deploying or destroying infrastructure live.
>
> Terraform manages one image resource and one FastAPI container. The Docker
> provider is pinned to version 4.7.0, and the lock file records its checksums.
> Variables control the image, tag, name and published port. Container labels
> identify the owner, course and lab. The application is bound to localhost
> port 8000. State stays local, while Git excludes state, private inputs,
> downloaded providers and saved plan binaries.

Prepare these files in the editor. Focus on `versions.tf` and `main.tf`; briefly
point to the other tabs instead of reading each file in full:

- [infra/versions.tf](infra/versions.tf): Terraform requirement, Docker provider
  **4.7.0**, local backend, and Docker socket.
- [infra/main.tf](infra/main.tf): `docker_image.api`, `keep_locally=true`,
  `docker_container.api`, ownership labels, `restart="unless-stopped"`, and
  `127.0.0.1:8000` mapped to container port 8000.
- [infra/variables.tf](infra/variables.tf) and
  [infra/terraform.tfvars.example](infra/terraform.tfvars.example): image/tag,
  owner, container name, and published port. Show the example, not local inputs.
- [infra/outputs.tf](infra/outputs.tf),
  [infra/.terraform.lock.hcl](infra/.terraform.lock.hcl), and [.gitignore](.gitignore).
  State, downloaded providers, local variables and saved plans stay outside Git.

## 2. Actual deployment — 1:35–2:25

Show the root README's verified-results table. Its initial-deployment entry
records **2 added, 0 changed, 0 destroyed**; there is no separate raw initial
apply log in the committed evidence. The later rebuild has a captured apply
log with the same resource counts. Outputs were:

```text
app_url        = "http://127.0.0.1:8000"
container_name = "ai381-lab4-churn-api"
health_url     = "http://127.0.0.1:8000/health"
```

Display the latest recorded container status:

```bash
cat evidence/api-audit-20261126-185623/01-container.json
```

> The README records the initial deployment as two additions, no changes and
> no destructions. Outputs identify the localhost application and health URLs
> and the container name. The final recorded API audit shows the rebuilt
> container running and healthy with restart policy unless-stopped. These are
> historical checks, not a fresh live inspection during filming.

## 3. Pull request and CI — 2:25–3:15

Open these exact GitHub pages:

1. [PR #1](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/pull/1):
   show **Merged**, then **Files changed**. The change set the restart policy
   to `unless-stopped`.
2. [PR CI run](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/actions/runs/45820246862):
   expand **Format, validate, and scan** and show the green steps.
3. [Final audit CI run](https://github.com/QotadaMaghairyh/AI381-Lab4-Terraform-Local/actions/runs/45854311938):
   passed for audited revision `d80abd8c54ccb381ecf806a2e05f72ca5042f0af`.

Show [.github/workflows/terraform.yml](.github/workflows/terraform.yml).
> PR number one changed the restart policy and was merged with a merge commit.
> Its Actions run passed, as did the linked final-audit run. The workflow checks
> formatting, initializes without deployment state, validates Terraform, and
> runs Trivy against infrastructure configuration. Actions use full commit
> SHAs. This does not demonstrate an application-image vulnerability scan.
> Plans and deployments run locally; GitHub has no apply job.

Point to `-backend=false -lockfile=readonly` in the workflow. Keep the second
CI tab ready as corroboration; do not repeat the whole job walkthrough.

PR merge commit: `63e1fc20a30197febecbf252bd1100f7a9c1645c`.
If the Node.js deprecation annotation is visible, explain that the checks
passed under Node.js 24 and updating action pins remains maintenance work.

## 4. Controlled drift and recovery — 3:15–4:15

Display the saved results; **do not repeat the manual change or apply**:

```bash
cat evidence/drift-20261126-183953/02-baseline-plan.txt
cat evidence/drift-20261126-183953/03-manual-drift.json
cat evidence/drift-20261126-183953/04-drift-plan.txt
cat evidence/drift-20261126-183953/06-recovery-apply.txt
cat evidence/drift-20261126-183953/09-after-summary.json
```

> The drift experiment started with a zero-change baseline. I changed only
> the Lab 4 container's restart policy to no, while Terraform still declared
> unless-stopped. The saved plan detected exactly one in-place correction,
> with no additions or destructions. Its detailed exit code two means a
> successful plan with changes. After inspecting that plan, I applied the
> correction. The recorded result is zero added, one changed and zero
> destroyed. The container ID stayed unchanged, health returned HTTP 200,
> and the final plan had no changes.

## 5. Controlled destroy and timed rebuild — 4:15–5:25

```bash
cat evidence/rebuild-20261126-184433/03-destroy-safety-check.json
grep -E 'Plan:|Destroy complete!|Exit code:' evidence/rebuild-20261126-184433/04-destroy.txt
cat evidence/rebuild-20261126-184433/05-post-destroy-check.json
grep -E 'Plan:|Apply complete!|Elapsed seconds:|Exit code:' evidence/rebuild-20261126-184433/06-timed-rebuild-apply.txt
cat evidence/rebuild-20261126-184433/07-rebuild-timing.json
cat evidence/rebuild-20261126-184433/10-after-summary.json
```

> For the controlled destroy, the safety check targeted only the two Lab 4
> Terraform resources. The container was removed, but keep-locally preserved
> the physical image. Both Lab 4 and original Lab 3 image tags retained their
> image IDs, and other containers were unchanged. Rebuilding from that existing
> image added two resources, changed none and destroyed none. The container
> ID changed, confirming recreation. The measured apply duration was exactly
> 3.332850438 seconds, using a monotonic nanosecond timer. It includes planning
> and creation, but excludes subsequent health checks; it is not image-build
> time. The final recorded plan had no changes.

Point to, rather than read aloud, the container IDs:

```text
Before: 26b5872cc00508382fd4f48bb3862a05144247912b4ce8c1d59edb7c3b3c951c
After:  e0d66327e1d3062f4d0c6817180e7ebcc67abf979f39e3122c3bb37347cd0279
```

Timing cross-check: the `time.monotonic_ns()` difference in the JSON is
**3,332,850,438 nanoseconds**. Show the saved value, not a new stopwatch run.

## 6. Health and prediction — 5:25–6:25

```bash
cat evidence/api-audit-20261126-185623/03-health.json
cat evidence/api-audit-20261126-185623/04-predict.json
```

Open [02-openapi.json](evidence/api-audit-20261126-185623/02-openapi.json)
in the editor and expand `response_body.components.schemas.CustomerInput`.
Show its five required fields, nonnegative numeric constraints, nonempty
strings, and `additionalProperties=false`. The recorded synthetic request was:

```json
{
  "tenure_months": 12,
  "monthly_fee": 65.5,
  "support_calls": 2,
  "contract": "Month-to-month",
  "internet_service": "Fiber optic"
}
```

> The saved OpenAPI schema requires five fields, with nonnegative numeric
> values, nonempty strings and no extra properties. This synthetic request
> follows that schema. The recorded health response was HTTP 200 with status
> ok. Prediction also returned HTTP 200, with churn probability 0.288. The
> health and prediction responses were captured on November 26 at about
> 18:56 Amman time. This verifies that request and API path, not model accuracy.

Exact evidence timestamps: health `2026-11-26T18:56:23.805650+03:00`;
prediction `2026-11-26T18:56:24.914707+03:00`. Do not read the timestamps aloud.

## 7. Scope and final submission checklist — 6:25–7:30

Show [SUBMISSION_CHECKLIST.md](SUBMISSION_CHECKLIST.md):

> The approved local work demonstrates provisioning, PR checks, drift recovery
> and a timed rebuild. Azure resource groups, Log Analytics, managed Container
> Apps, autoscaling, public managed HTTPS, Entra OIDC, Azure remote state and
> cost controls were not implemented. The starter budget is optional. Apply
> and smoke tests are manual; automatic PR plan comments, explicit starter
> CPU and memory limits, and an immutable CI image tag are also absent.
> The full e-learning rubric remains unavailable locally, so I still need to
> confirm packaging, video and screenshot requirements. The URL file and
> sanitized evidence are ready. This recording displays evidence without
> changing infrastructure.

Show the ready URL file:

```bash
cat repo.txt
```

Before submission:

- [ ] Review the finished recording for readable text, audible individual
  explanation, and a duration within the requested 5–8 minutes.
- [ ] Keep historical evidence clearly identified; do not claim a new live
  destroy/rebuild or current test during this recording.
- [ ] Check the full official e-learning rubric, upload format, deadline,
  required screenshots, and whether `repo.txt` must be uploaded separately.
  These details are not established by the available starter.
- [ ] Include instructor approval documentation if requested; none is stored
  in this repository. Local deployment and the separate repository are approved
  according to the student's confirmation.
- [ ] Check coverage against the actual rubric; this guide does not establish
  official video length or screenshot-count requirements.
- [ ] Submit the public repository URL, requested recording/screenshots, and
  other confirmed artifacts. Recording this guide does not upload a video.
- [ ] Keep credentials, state, local variables, and saved plan binaries off-screen
  and out of the submission. Do not execute commands copied from evidence logs.

Evidence navigation: [evidence/README.md](evidence/README.md).
This guide was prepared without rerunning apply/destroy or changing Docker
resources. It remains uncommitted pending review.
