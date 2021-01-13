provider "aws" {
    region = "us-east-1"
    profile = "528922625383_cg-assessments-limited-admin"
}

terraform {
  /*backend "s3" {
      bucket = "terraform-state-backend-assignment"
      key = "nishant/static_website/terraform.tfstate"
      region = "us-east-1"
  }*/
    backend "local" {
      path = "./terraform.tfstate"
    }
}