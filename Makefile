ENV ?= dev

START ?=
END ?=
NAME ?= replay-$(ENV)-$(shell date +%s)

TF_DIR=environments/$(ENV)

ARCHIVE_ARN=$(shell terraform -chdir=$(TF_DIR) output -raw archive_arn)
BUS_ARN=$(shell terraform -chdir=$(TF_DIR) output -raw event_bus_arn)
STATE_MACHINE_ARN=$(shell terraform -chdir=$(TF_DIR) output -raw replay_state_machine_arn)

replay:
ifndef START
	$(error START is required: START=2026-04-01T00:00:00Z)
endif
ifndef END
	$(error END is required: END=2026-04-01T01:00:00Z)
endif
	aws stepfunctions start-execution \
		--state-machine-arn $(STATE_MACHINE_ARN) \
		--input '{"replay_name":"$(NAME)","archive_arn":"$(ARCHIVE_ARN)","event_bus_arn":"$(BUS_ARN)","start_time":"$(START)","end_time":"$(END)"}'