output "tags" {
  description = "Global tags applied to all resources"
  value       = local.global_tags
}

output "environment" {
  value = var.environment
}