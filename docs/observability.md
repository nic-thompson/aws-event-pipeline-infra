# Observability

## Overview

`aws-event-pipeline-infra` exposes infrastructure-level observability using AWS-native telemetry surfaces.

These include:

- Step Functions execution history
- EventBridge replay status
- DynamoDB audit tables
- SQS queue metrics
- CloudWatch metrics and logs

Together they provide visibility into pipeline execution behaviour.

---

## Replay Workflow Observability

Replay execution visibility is available through:

aws stepfunctions list-executions

and:

aws stepfunctions get-execution-history

Replay metadata is persisted to:

replay_audit_table

Example record fields:

- replay_name
- start_time
- end_time
- status

Typical status:

STARTED

Replay completion polling is not currently implemented.

---

## Dataset Export Observability

Export workflows record lifecycle state in:

export_audit_table

Example fields:

- export_id
- requested_at
- status

Status transitions:

STARTED → COMPLETED

These confirm dataset snapshot creation.

---

## SQS Monitoring

Each pipeline queue exposes:

- message count
- DLQ depth
- retry behaviour

Example inspection:

aws sqs get-queue-attributes

Queue depth helps detect downstream processor issues.

---

## Archive Replay Visibility

Replay state can be inspected using:

aws events describe-replay

Fields:

- ReplayStartTime
- ReplayEndTime
- State

Typical states:

STARTING  
RUNNING  
COMPLETED  
FAILED

---

## Step Functions Execution Logs

Execution traces show:

- state entry
- state exit
- service calls
- errors
- retries

Example:

ExecutionStarted  
TaskStateEntered  
TaskScheduled  
ExecutionSucceeded

These provide deterministic debugging signals.

---

## Export Artefact Verification

Export outputs can be confirmed via:

aws s3 ls s3://<bucket>/exports/

Example:

export-dev-test-060.json

Presence confirms workflow completion.

---

## Recommended Future Extensions

Possible improvements:

- CloudWatch dashboards
- replay latency metrics
- queue depth alarms
- export workflow failure alerts
- structured execution logging