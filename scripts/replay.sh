#!/usr/bin/env bash
set -euo pipefail

ENV="${ENV:-dev}"
START="${START:?START is required}"
END="${END:?END is required}"
TYPE="${TYPE:-}"

TF_DIR="environments/${ENV}"

ARCHIVE_ARN=$(terraform -chdir="${TF_DIR}" output -raw archive_arn)
BUS_ARN=$(terraform -chdir="${TF_DIR}" output -raw event_bus_arn)
STATE_MACHINE_ARN=$(terraform -chdir="${TF_DIR}" output -raw replay_state_machine_arn)

NAME="replay-${ENV}-$(date +%s)"

if [[ -n "$TYPE" ]]; then
  INPUT=$(jq -n \
    --arg replay_name "$NAME" \
    --arg archive_arn "$ARCHIVE_ARN" \
    --arg event_bus_arn "$BUS_ARN" \
    --arg start_time "$START" \
    --arg end_time "$END" \
    --arg type "$TYPE" \
    '{
      replay_name: $replay_name,
      archive_arn: $archive_arn,
      event_bus_arn: $event_bus_arn,
      start_time: $start_time,
      end_time: $end_time,
      event_pattern: {("detail-type"): [$type]}
    }')
else
  INPUT=$(jq -n \
    --arg replay_name "$NAME" \
    --arg archive_arn "$ARCHIVE_ARN" \
    --arg event_bus_arn "$BUS_ARN" \
    --arg start_time "$START" \
    --arg end_time "$END" \
    '{
      replay_name: $replay_name,
      archive_arn: $archive_arn,
      event_bus_arn: $event_bus_arn,
      start_time: $start_time,
      end_time: $end_time
    }')
fi

aws stepfunctions start-execution \
  --state-machine-arn "$STATE_MACHINE_ARN" \
  --input "$INPUT"