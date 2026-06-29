# GitHub Actions Notes

> Personal notes from implementing CI/CD in the AWS Serverless Pipeline project.

---

# Mental Model

GitHub Actions is an orchestration framework.

A workflow responds to repository events and coordinates one or more independent jobs.

```text
Git Push / Pull Request
            │
            ▼
        Workflow
            │
            ▼
          Jobs
            │
            ▼
          Steps
```

Jobs are loosely coupled and execute independently by default.

Communication between jobs only happens through outputs.

---

# Workflow

A workflow is triggered by repository events.

Examples:

- push
- pull_request
- workflow_dispatch
- schedule

Example:

```yaml
name: CI

on:
  push:
  pull_request:
```

---

# Job

A job is an independent worker.

Each job:

- Runs on its own VM (runner)
- Performs one responsibility
- Can expose outputs
- Can depend on other jobs

Common properties:

- runs-on
- permissions
- env
- defaults
- outputs
- steps

---

# Step

A step performs one task.

Examples:

- Checkout repository
- Setup Terraform
- Run Tests
- Build Docker Image

Common properties:

- name
- id
- uses
- run
- with
- env

---

# Step ID

Every step can have an id.

Example:

```yaml
- id: check-terraform
```

The id gives the step an identity so other parts of the workflow can reference its outputs.

Example:

```yaml
steps.check-terraform.outputs.changed
```

Without an id, the step cannot be referenced.

---

# Outputs

Outputs allow information to flow between jobs.

Flow:

```text
Step
    │
    ▼
Step Output
    │
    ▼
Job Output
    │
    ▼
Another Job
```

Step outputs are written to GitHub's special output file.

Example:

```bash
echo "changed=true" >> "$GITHUB_OUTPUT"
```

This is **not** printing to the console.

GitHub watches this file and registers the values as step outputs.

---

# Job Outputs

Jobs expose selected step outputs.

Example:

```yaml
outputs:
  terraform_changed: ${{ steps.check-terraform.outputs.changed }}
```

Read as:

> Expose the "changed" output from the "check-terraform" step as the public job output "terraform_changed".

---

# needs

Controls execution order.

Example:

```yaml
terraform:
  needs: detect-changes
```

Meaning:

Terraform waits until detect-changes finishes.

---

# if

Determines whether a job should execute.

Example:

```yaml
if: needs.detect-changes.outputs.terraform_changed == 'true'
```

Read as:

Run this job only if Terraform changed.

---

# Detect Changes Pattern

```text
Git Event
      │
      ▼
Detect Changes Job
      │
      ▼
git diff
      │
      ▼
Step Output
      │
      ▼
Job Output
      │
      ▼
Terraform Job
Spring Job
Docker Job
...
```

---

# Git Diff

Purpose:

Compare two Git states.

Example:

```bash
git diff HEAD~1 HEAD
```

Compare:

```text
Previous Commit
        │
        ▼
Current Commit
```

Path filtering:

```bash
git diff HEAD~1 HEAD -- terraform/
```

Only compare files inside:

```text
terraform/
```

---

# Bash Notes

Multi-line script:

```yaml
run: |
```

Explicit shell:

```yaml
shell: bash
```

Variable expansion:

```bash
echo "$MY_VAR"
```

Append to file:

```bash
>>
```

if statement:

```bash
if command; then
    ...
else
    ...
fi
```

Commands are evaluated using exit codes.

---

# Exit Codes

```text
0  -> Success

!= 0 -> Failure / Non-success status
```

GitHub Actions and Bash use exit codes to make decisions.

---

# Design Principles

Jobs should be:

- Independent
- Loosely coupled
- Single responsibility

Communication should happen through outputs.

Ordering should happen through needs.

Conditional execution should happen through if.

---

# Traffic Analogy

Workflow = City

Jobs = Cars

needs = Traffic lights

outputs = Information exchanged

if = Decision whether to continue

By default, every car drives independently unless it must wait for another.

---

# Pattern

Every new CI job follows the same pattern.

```text
Detect
    │
    ▼
Produce Output
    │
    ▼
Expose Output
    │
    ▼
Consume Output
    │
    ▼
Execute
```

Only the implementation changes.

Examples:

- Terraform
- Spring
- Docker
- Go
- Python
- Kubernetes

Same architecture.