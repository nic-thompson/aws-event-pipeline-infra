variable "environment" {
  description = "Environment name"
  type        = string
}

variable "event_bus_arn" {
  description = "EventBridge bus ARN"
  type        = string
}

variable "retention_days" {
  description = "Archive retention period"
  type        = number
}

