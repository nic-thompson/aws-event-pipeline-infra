variable "environment" {
  description = "Deployment environment name (dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Common resource tags applied to the audit table"
  type        = map(string)
}
