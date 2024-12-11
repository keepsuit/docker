terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"

  backend "s3" {
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}
