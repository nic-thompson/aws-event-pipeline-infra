# Architecture

## Overview

`aws-event-pipeline-infra` provisions a modular AWS event-processing backbone using Terraform.

The repository defines infrastructure for:

- EventBridge event routing
- archive-based event replay
- SQS pipeline stage isolation
- Step Functions orchestration workflows
- DynamoDB lineage tracking tables
- encrypted S3 dataset export artefacts
- environment-isolated deployments

It is designed as reusable infrastructure for event-driven data and telemetry pipelines.

---

## High-Level Topology

The deployed architecture follows this structure:

Event Producers
↓
EventBridge Bus
↓
EventBridge Rules (detail-type routing)
↓
SQS Processing Queues
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

Each component is provisioned via a dedicated Terraform module.

---

## Core Infrastructure Components

### EventBridge Bus

Module:

modules/eventbridge_bus

Provides:

- environment-scoped event bus
- contract-based routing surface
- archive replay destination
- queue fan-out targets

All pipeline events enter through this bus.

---

### Event Routing Rules

Module:

modules/eventbridge_rule_to_sqs

Creates rules routing events by `detail-type`.

Example routed event types:

- telemetry.ingested
- telemetry.validated
- telemetry.enriched
- feature.generated
- dataset.export-requested

Each rule targets a dedicated queue.

---

### Pipeline Queues

Module:

modules/pipeline_queue

Each processing stage receives its own queue:

| Queue | Purpose |
|------|---------|
| ingestion | raw event intake |
| validation | schema enforcement stage |
| enrichment | derived attribute stage |
| feature | feature generation stage |
| dataset-export | export workflow trigger |

Queues include:

- DLQs
- configurable visibility timeout
- configurable retention
- KMS encryption

This enables independent scaling and failure isolation.

---

### EventBridge Archive

Module:

modules/eventbridge_archive

Provides:

- replayable event storage
- configurable retention window
- deterministic reconstruction support

Archive replay is orchestrated using Step Functions.

---

### Replay Workflow

Module:

modules/eventbridge_replay_workflow

Implements a Step Functions state machine that:

1. records replay metadata
2. starts archive replay
3. writes lineage status

Replay metadata is stored in:

replay_audit_table

This enables traceable historical reconstruction.

---

### Dataset Export Workflow

Module:

modules/dataset_export_job

Implements:

RecordExportStarted  
→ WriteExportObject  
→ RecordExportCompleted

Responsibilities:

- persist export lineage metadata
- generate snapshot artefacts
- write encrypted S3 outputs
- update completion status

Exports are stored under:

s3://<event-archive-bucket>/exports/

---

### Audit Tables

Replay metadata table:

modules/replay_audit_table

Export metadata table:

modules/export_audit_table

These tables record:

| Field | Purpose |
|------|---------|
| execution id | workflow identifier |
| timestamps | lifecycle tracking |
| status | workflow state |

Together they provide infrastructure-level lineage tracking.

---

### Encryption

Module:

modules/kms

Provides:

- SQS encryption
- S3 encryption
- workflow permissions
- environment-specific key aliasing

All stored artefacts are encrypted at rest.