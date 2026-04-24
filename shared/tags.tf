locals {
  global_tags = {
    project     = var.project_name
    environment = var.environment
    owner       = var.owner
    managed_by  = "terraform"
  }
}