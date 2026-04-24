provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for backend infrastructure"
  type        = string
}