locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

output "name_prefix" {
  value = local.name_prefix
}