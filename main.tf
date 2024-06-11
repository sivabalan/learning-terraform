terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.53.0"
    }
  }

    backend "s3" {
    bucket = "main-bucket-tfstate"
    key    = "kumars-tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region =  "us-east-2"  #Ohio Region
}