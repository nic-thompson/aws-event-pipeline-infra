# aws-event-pipeline-infra

Terraform infrastructure for a modular AWS event-processing backbone supporting EventBridge routing, archive replay, dataset export workflows, and environment-isolated deployments.

This repository provisions reusable infrastructure for event-driven data and telemetry pipelines.

---

## Overview

aws-event-pipeline-infra defines a production-style event pipeline foundation built from:

- EventBridge event routing
- archive-based replay workflows
- SQS stage isolation queues
- Step Functions orchestration
- DynamoDB lineage tracking tables
- encrypted S3 export artefacts
- environment-scoped deployments

The architecture supports deterministic replay, reproducible dataset generation, and traceable pipeline execution.

---

## Repository Structure

aws-event-pipeline-infra/

bootstrap/  
docs/  
 architecture.md  
 environments.md  
 observability.md  
 replay-strategy.md  

environments/  
 dev/  
 staging/  
 prod/  

modules/  
 dataset_export_job/  
 event_archive_bucket/  
 eventbridge_archive/  
 eventbridge_bus/  
 eventbridge_replay_workflow/  
 eventbridge_rule_to_sqs/  
 kms/  
 pipeline_queue/  
 replay_audit_table/  
 export_audit_table/  

scripts/  
 replay.sh  

shared/  

Makefile

Infrastructure follows a layered composition model:

| Layer | Purpose |
|------|---------|
| shared | naming and tagging conventions |
| modules | reusable infrastructure primitives |
| environments | deployment entrypoints |

---

## Architecture Summary

High-level topology:

Event Producers  
↓  
EventBridge Bus  
↓  
EventBridge Rules (detail-type routing)  
↓  
Stage-isolated SQS queues  
↓  
EventBridge Archive  
↓  
Replay Workflow (Step Functions)  
↓  
Dataset Export Workflow (Step Functions)  
↓  
S3 Export Artefacts  
↓  
DynamoDB Audit Tables  

This design enables:

- deterministic replay
- lineage tracking
- dataset reconstruction
- pipeline backfill support
- environment isolation

---

## Provisioned Infrastructure

### EventBridge Bus

Provides the routing backbone for pipeline events.

Module:

modules/eventbridge_bus

---

### Event Routing Rules

Routes events by detail-type into stage-specific queues:

- telemetry.ingested
- telemetry.validated
- telemetry.enriched
- feature.generated
- dataset.export-requested

Module:

modules/eventbridge_rule_to_sqs

---

### Stage Processing Queues

Each processing stage receives an isolated queue:

| Queue | Purpose |
|------|---------|
| ingestion | raw intake |
| validation | schema enforcement |
| enrichment | derived attributes |
| feature | feature generation |
| dataset-export | snapshot workflow trigger |

Module:

modules/pipeline_queue

Queues include DLQs and encryption.

---

### EventBridge Archive

Stores replayable event history for deterministic reconstruction.

Module:

modules/eventbridge_archive

---

### Replay Workflow

Step Functions workflow that:

1. records replay metadata
2. starts EventBridge archive replay
3. tracks execution lineage

Module:

modules/eventbridge_replay_workflow

Metadata stored in:

replay_audit_table

---

### Dataset Export Workflow

Step Functions workflow that:

1. records export request
2. writes snapshot artefact to S3
3. marks export completion

Module:

modules/dataset_export_job

Outputs stored in:

s3://<event-archive-bucket>/exports/

---

### Audit Tables

Replay lineage:

modules/replay_audit_table

Export lineage:

modules/export_audit_table

Track:

- execution identifiers
- timestamps
- workflow status

---

### Encryption

All storage resources use KMS-backed encryption.

Module:

modules/kms

Encrypts:

- SQS queues
- S3 export artefacts
- workflow access paths

---

## Environments

Supported environments:

- dev
- staging
- prod

Each environment provisions:

- independent EventBridge bus
- archive storage
- queues
- workflows
- audit tables
- export bucket
- KMS key

Deploy using:

terraform -chdir=environments/dev init  
terraform -chdir=environments/dev apply

Environment isolation prevents cross-stage interference.

---

## Replay Execution

Replay archive events within a time window:

make replay START=<timestamp> END=<timestamp> TYPE=<detail-type>

Example:

make replay START=2026-04-27T14:20:09Z END=2026-04-27T14:30:09Z TYPE=telemetry.enriched

Replay metadata is recorded in:

replay_audit_table

---

## Dataset Export Execution

Start dataset export workflow:

aws stepfunctions start-execution \
  --state-machine-arn <dataset-export-arn> \
  --input '{
    "export_id": "export-dev-test-001",
    "requested_at": "2026-04-27T17:00:00Z"
  }'

Outputs written to:

s3://<archive-bucket>/exports/

Export metadata recorded in:

export_audit_table

---

## Observability

Replay status:

aws events describe-replay

Workflow executions:

aws stepfunctions list-executions

Execution history:

aws stepfunctions get-execution-history

Export artefacts:

aws s3 ls s3://<bucket>/exports/

Audit records:

aws dynamodb scan --table-name <audit-table>

These provide deterministic debugging signals.

---

## Security Model

Infrastructure enforces:

- environment isolation
- least-privilege IAM roles
- KMS encryption
- queue-level DLQs
- archive retention controls

All persisted artefacts are encrypted at rest.

---

## Documentation

Additional documentation:

| File | Description |
|------|-------------|
| docs/architecture.md | system topology |
| docs/environments.md | deployment structure |
| docs/observability.md | monitoring surfaces |
| docs/replay-strategy.md | archive replay workflow |

---

## Intended Usage

This repository provides a reusable infrastructure baseline for:

- telemetry pipelines
- ML feature ingestion systems
- replayable event architectures
- dataset snapshot workflows
- contract-driven event platforms

It is designed for extension rather than direct application-level processing.