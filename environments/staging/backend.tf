terraform {
  backend "s3" {
    bucket         = "signalforge-staging-terraform-state"
    key            = "pipeline-infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "signalforge-staging-terraform-locks"
    encrypt        = true
  }
}