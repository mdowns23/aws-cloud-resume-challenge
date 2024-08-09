terraform {
  required_providers {
    aws = {
        version = ">= 4.9.0"
        source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    //profile ="cloud-resume-infra"
    access_key = "var.AWS_ACCESS_KEY_ID2"
    secret_key = "var.AWS_SECRET_ACCESS_KEY2"
    region = "us-west-2"
}


