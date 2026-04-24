variable "environment" {
  description = "Deployment environment name (dev, staging, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy infrastructure into"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Project identifier used for naming resources"
  type        = string
  default     = "signalforge"
}

variable "owner" {
  description = "Infrastructure owner"
  type        = string
  default     = "platform"
}