# Environments

## Overview

`aws-event-pipeline-infra` supports multiple isolated deployments using identical Terraform modules.

Each environment provisions a fully independent event-processing stack.

Supported environments:

- dev
- staging
- prod

Each environment has its own:

- EventBridge bus
- archive
- queues
- workflows
- audit tables
- export bucket
- encryption key

---

## Environment Layout

Structure:

environments/
 ├── dev/
 ├── staging/
 └── prod/

Each directory defines:

- backend.tf
- main.tf

These configure remote state and module composition.

---

## Naming Convention

Resource naming follows:

<project>-<environment>-<account>-<region>-<resource>

Example:

signalforge-dev-081277286841-eu-west-2-enrichment-queue

This ensures:

- uniqueness
- traceability
- environment clarity

---

## Terraform State Isolation

Each environment maintains separate remote state.

Typical workflow:

terraform -chdir=environments/dev init  
terraform -chdir=environments/dev apply

This prevents cross-environment modification.

---

## Deployment Order

Recommended deployment flow:

dev → staging → prod

This supports validation before production rollout.

---

## Archive Retention Strategy

Retention duration is configurable per environment.

Typical configuration:

| Environment | Retention |
|------------|-----------|
| dev | short-term experimentation |
| staging | integration validation |
| prod | long-term reproducibility |

---

## Promotion Strategy

Infrastructure promotion follows:

module change  
→ dev apply  
→ staging apply  
→ prod apply

This ensures reproducibility across environments.