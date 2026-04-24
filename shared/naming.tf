data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
}

output "name_prefix" {
  value = local.name_prefix
}