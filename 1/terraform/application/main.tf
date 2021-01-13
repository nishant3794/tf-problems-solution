provider "aws" {
    region = "us-east-1"
    profile = "528922625383_cg-assessments-limited-admin"
}

terraform {
  /*backend "s3" {
      bucket = "Bucket_name"
      key = "location_where_tfstate_needs_to_save"
      region = "region_of_bucket"
  }*/
    backend "local" {
      path = "./terraform.tfstate"
    }
}

data "aws_acm_certificate" "cert" {
    domain = "assessments.coda.run"
    types = [ "AMAZON_ISSUED" ]
    most_recent = true
}

data "aws_route53_zone" "zone" {
    name = "assessments.coda.run."
    private_zone = false
}