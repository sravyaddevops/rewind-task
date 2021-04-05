terraform {
   required_version = ">= 0.12.2"
   required_providers {
     aws = ">= 2.17.0"
   }
   backend "s3" {
    bucket = "<<<S3_BUCKETNAME>>" //S3 bucket 
    key    = "state.tf"
    region = "us-east-1" 
    acl    = "private"
    dynamodb_table = "terraform-state-lock-dynamo"
   }
}

provider "aws" {
  region  = "us-east-1"
  profile = "dev-mfa-token" //AWS PROFILE
}

provider "local" {
  version = "~> 1.2"
}

locals {
  default_tags = {
    Environment = var.environment 
    Owner       = var.owner 
    Service     = var.service 
  }
  tg_tags = {
    associated_lb = var.associated_lb 
  }
  domain_name = var.domain_name 
}

data "aws_route53_zone" "this" {
  name = local.domain_name
}

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id
}
data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}