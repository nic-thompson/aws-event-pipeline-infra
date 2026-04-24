variable "name_prefix" {
  description = "Prefix used for naming resources"
  type        = string
}

variable "queue_name" {
  description = "Logical queue name (ingestion, validation, etc)"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "Queue visibility timeout"
  type        = number
}

variable "message_retention_seconds" {
  description = "How long messages remain in the queue"
  type        = number
}

variable "max_receive_count" {
  description = "Retries before moving message to DLQ"
  type        = number
}

variable "dlq_retention_seconds" {
  description = "DLQ message retention"
  type        = number
  default     = 1209600
}