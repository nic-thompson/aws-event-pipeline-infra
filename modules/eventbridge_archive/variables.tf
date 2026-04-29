variable "environment" {
  description = "Environment name"
  type        = string
}

variable "event_bus_arn" {
  description = "EventBridge bus ARN"
  type        = string
}

variable "retention_days" {
  description = "Archive retention period in days"
  type        = number
}

variable "event_pattern" {
  description = "JSON event pattern to filter which events are archived. Defaults to all events on the bus."
  type        = string
  default     = null
}
