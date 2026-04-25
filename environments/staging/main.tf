module "kms" {
  source = "../../modules/kms"

  alias_name = "signalforge-staging"
  tags       = module.shared.tags
}

module "shared" {
  source = "../../shared"

  environment = "staging"
  aws_region  = "eu-west-2"
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

