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

variable "target_queue_arn" {
  description = "Optional downstream queue ARN for targeted replay workflows (reserved for future selective replay routing)"
  type        = string
}

variable "tags" {
  description = "Standard resource tags applied to replay infrastructure"
  type        = map(string)
}

variable "replay_audit_table_arn" {
  type = string
}

variable "replay_audit_table_name" {
  type = string
}