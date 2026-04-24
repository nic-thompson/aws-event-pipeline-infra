terraform {
  backend "s3" {
    bucket         = "signalforge-prod-terraform-state"
    key            = "pipeline-infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "signalforge-prod-terraform-locks"
    encrypt        = true
  }
}