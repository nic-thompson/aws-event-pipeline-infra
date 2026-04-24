terraform {
  backend "s3" {
    bucket         = "signalforge-dev-terraform-state-081277286841"
    key            = "pipeline-infra/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "signalforge-dev-terraform-locks"
    encrypt        = true
  }
}