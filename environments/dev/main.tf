module "shared" {
  source = "../../shared"

  environment = "dev"
  aws_region  = "eu-west-2"
}


module "kms" {
  source = "../../modules/kms"

  alias_name = "signalforge-dev"
  tags       = module.shared.tags
}


module "ingestion_queue" {
  source = "../../modules/pipeline_queue"

  name_prefix = module.shared.name_prefix
  queue_name  = "ingestion"

  visibility_timeout_seconds = 90
  message_retention_seconds  = 345600
  max_receive_count          = 5

  kms_key_arn = module.kms.kms_key_arn
}


module "validation_queue" {
  source = "../../modules/pipeline_queue"

  name_prefix = module.shared.name_prefix
  queue_name  = "validation"

  visibility_timeout_seconds = 120
  message_retention_seconds  = 345600
  max_receive_count          = 5

  kms_key_arn = module.kms.kms_key_arn
}


module "enrichment_queue" {
  source = "../../modules/pipeline_queue"

  name_prefix = module.shared.name_prefix
  queue_name  = "enrichment"

  visibility_timeout_seconds = 180
  message_retention_seconds  = 345600
  max_receive_count          = 5

  kms_key_arn = module.kms.kms_key_arn
}


module "feature_queue" {
  source = "../../modules/pipeline_queue"

  name_prefix = module.shared.name_prefix
  queue_name  = "feature"

  visibility_timeout_seconds = 180
  message_retention_seconds  = 345600
  max_receive_count          = 5

  kms_key_arn = module.kms.kms_key_arn
}


module "dataset_export_queue" {
  source = "../../modules/pipeline_queue"

  name_prefix = module.shared.name_prefix
  queue_name  = "dataset-export"

  visibility_timeout_seconds = 300
  message_retention_seconds  = 604800
  max_receive_count          = 8

  kms_key_arn = module.kms.kms_key_arn
}


module "event_archive_bucket" {
  source = "../../modules/event_archive_bucket"

  name_prefix = module.shared.name_prefix
  kms_key_arn = module.kms.kms_key_arn
}


module "eventbridge_bus" {
  source = "../../modules/eventbridge_bus"

  name_prefix = module.shared.name_prefix
  tags        = module.shared.tags
}


module "event_archive" {
  source = "../../modules/eventbridge_archive"

  environment    = "dev"
  event_bus_arn  = module.eventbridge_bus.eventbridge_bus_arn
  retention_days = 730
}


########################################
# Replay audit table (must exist first)
########################################

module "replay_audit_table" {
  source = "../../modules/replay_audit_table"

  environment = "dev"
  tags        = module.shared.tags
}


########################################
# Replay workflow
########################################

module "replay_workflow" {
  source = "../../modules/eventbridge_replay_workflow"

  environment   = "dev"
  archive_arn   = module.event_archive.archive_arn
  event_bus_arn = module.eventbridge_bus.eventbridge_bus_arn

  replay_audit_table_arn  = module.replay_audit_table.table_arn
  replay_audit_table_name = module.replay_audit_table.table_name

  tags = module.shared.tags
}


########################################
# Event routing rules
########################################

module "route_ingested_events" {
  source = "../../modules/eventbridge_rule_to_sqs"

  name_prefix    = module.shared.name_prefix
  rule_name      = "telemetry-ingested"
  detail_type    = "telemetry.ingested"
  event_bus_name = module.eventbridge_bus.eventbridge_bus_name

  queue_arn = module.ingestion_queue.queue_arn
  queue_url = module.ingestion_queue.queue_url

  tags = module.shared.tags
}


module "route_validated_events" {
  source = "../../modules/eventbridge_rule_to_sqs"

  name_prefix    = module.shared.name_prefix
  rule_name      = "telemetry-validated"
  detail_type    = "telemetry.validated"
  event_bus_name = module.eventbridge_bus.eventbridge_bus_name

  queue_arn = module.validation_queue.queue_arn
  queue_url = module.validation_queue.queue_url

  tags = module.shared.tags
}


module "route_enriched_events" {
  source = "../../modules/eventbridge_rule_to_sqs"

  name_prefix    = module.shared.name_prefix
  rule_name      = "telemetry-enriched"
  detail_type    = "telemetry.enriched"
  event_bus_name = module.eventbridge_bus.eventbridge_bus_name

  queue_arn = module.enrichment_queue.queue_arn
  queue_url = module.enrichment_queue.queue_url

  tags = module.shared.tags
}


module "route_generated_events" {
  source = "../../modules/eventbridge_rule_to_sqs"

  name_prefix    = module.shared.name_prefix
  rule_name      = "feature-generated"
  detail_type    = "feature.generated"
  event_bus_name = module.eventbridge_bus.eventbridge_bus_name

  queue_arn = module.feature_queue.queue_arn
  queue_url = module.feature_queue.queue_url

  tags = module.shared.tags
}


module "route_export_events" {
  source = "../../modules/eventbridge_rule_to_sqs"

  name_prefix    = module.shared.name_prefix
  rule_name      = "dataset-export-requested"
  detail_type    = "dataset.export-requested"
  event_bus_name = module.eventbridge_bus.eventbridge_bus_name

  queue_arn = module.dataset_export_queue.queue_arn
  queue_url = module.dataset_export_queue.queue_url

  tags = module.shared.tags
}


########################################
# Export audit table (must exist first)
########################################

module "export_audit_table" {
  source = "../../modules/export_audit_table"

  environment = "dev"
  tags        = module.shared.tags
}


########################################
# Dataset export workflow
########################################

module "dataset_export_job" {
  source = "../../modules/dataset_export_job"

  environment = "dev"

  export_bucket_name = module.event_archive_bucket.bucket_name
  export_bucket_arn  = module.event_archive_bucket.bucket_arn

  export_audit_table_name = module.export_audit_table.table_name
  export_audit_table_arn  = module.export_audit_table.table_arn

  kms_key_arn = module.kms.kms_key_arn

  tags = module.shared.tags
}


########################################
# Outputs
########################################

output "archive_arn" {
  value = module.event_archive.archive_arn
}


output "event_bus_arn" {
  value = module.eventbridge_bus.eventbridge_bus_arn
}


output "replay_state_machine_arn" {
  value = module.replay_workflow.state_machine_arn
}


output "enrichment_queue_url" {
  value = module.enrichment_queue.queue_url
}


output "replay_audit_table_name" {
  value = module.replay_audit_table.table_name
}