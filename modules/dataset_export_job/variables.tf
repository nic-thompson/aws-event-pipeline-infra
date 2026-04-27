variable "environment" {
  type = string
}

variable "export_bucket_name" {
  type = string
}

variable "export_bucket_arn" {
  type = string
}

variable "export_audit_table_name" {
  type = string
}

variable "export_audit_table_arn" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "tags" {
  type = map(string)
}