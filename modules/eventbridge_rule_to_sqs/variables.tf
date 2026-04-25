variable "name_prefix" {
  type = string
}

variable "rule_name" {
  type = string
}

variable "detail_type" {
  type = string
}

variable "event_bus_name" {
  type = string
}

variable "queue_arn" {
  type = string
}

variable "queue_url" {
  type = string
}

variable "tags" {
  type = map(string)
}