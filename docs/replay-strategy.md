# Replay Strategy

## Overview

`aws-event-pipeline-infra` implements archive-based replay using EventBridge archives and Step Functions orchestration.

Replay enables deterministic reinjection of historical events into the pipeline.

This supports:

- dataset reconstruction
- regression testing
- pipeline backfills
- downstream processor recovery

---

## Replay Architecture

Replay workflow:

Archive Window Selection  
↓  
Step Functions Execution  
↓  
StartReplay API  
↓  
EventBridge Reinjection  
↓  
Queue Redistribution

Replay metadata is stored in:

replay_audit_table

---

## Replay Execution Flow

State machine:

RecordReplayStarted  
→ StartReplay  
→ RecordReplayCompleted (optional future extension)

Current implementation records:

STARTED

status at replay initiation.

---

## Replay Filters

Replay supports filtering by:

detail-type

Example:

telemetry.enriched

Execution example:

make replay START=<timestamp> END=<timestamp> TYPE=telemetry.enriched

---

## Replay Window Selection

Replay windows are defined using:

START  
END

Example:

START=2026-04-27T14:20:09Z  
END=2026-04-27T14:30:09Z

These timestamps bound archive extraction.

---

## Replay Metadata Tracking

Each replay records:

- replay_name
- start_time
- end_time
- status

Stored in:

replay_audit_table

This enables lineage-aware reconstruction.

---

## Asynchronous Replay Behaviour

EventBridge replay executes asynchronously.

StartReplay returns immediately.

Future extension:

StartReplay  
→ Wait  
→ DescribeReplay  
→ loop until COMPLETED

This enables lifecycle-aware tracking.

---

## Replay Use Cases

Replay infrastructure supports:

| Scenario | Purpose |
|---------|---------|
| dataset rebuild | regenerate historical features |
| processor recovery | recover failed downstream services |
| schema validation | test contract evolution |
| integration testing | simulate historical load |

Replay is environment-scoped and non-destructive.