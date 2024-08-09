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
    
    region = "us-west-2"
}


