terraform {
  required_version = ">= 0.12.2"
  backend "s3" {
    bucket = "sample" // bucket name 
    key    = "state.tf"
    region = "us-east-1"
    acl    = "private"
    dynamodb_table = "terraform-state-lock-dynamo"
  }
}

provider "aws" {
  version = ">= 2.17.0"
  region  = "us-east-1"
  profile = "dev-mfa"
}

provider "local" {
  version = "~> 1.2"
}

locals {
  project_name = "rewind"
  default_tags = {
    Owner = "Development"
    Environment = "staging"
    Project_Name = "rewind"
  }
}

data "aws_region" "current" {} 
