terraform {
  backend "s3" {
    bucket         = "signalforge-terraform-state-081277286841-eu-west-2"
    key            = "environments/prod/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "signalforge-terraform-locks"
    encrypt        = true
  }
}