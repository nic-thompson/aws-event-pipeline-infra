variable "alias_name" {
  description = "Alias name for KMS key"
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}
