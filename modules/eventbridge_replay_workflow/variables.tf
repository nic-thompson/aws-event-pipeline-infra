variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "archive_arn" {
  description = "ARN of the EventBridge archive to replay from"
  type        = string
}

variable "event_bus_arn" {
  description = "ARN of the EventBridge bus that receives replayed events"
  type        = string
}

variable "tags" {
  description = "Standard resource tags applied to replay infrastructure"
  type        = map(string)
}

variable "replay_audit_table_arn" {
  description = "ARN of the DynamoDB table used to record replay execution metadata"
  type        = string
}

variable "replay_audit_table_name" {
  description = "Name of the DynamoDB table used to record replay execution metadata"
  type        = string
}