terraform {
   required_version = ">= 0.12.2"
   required_providers {
     aws = ">= 2.17.0"
   }
   backend "s3" {
    bucket = "" // S3 bucket
    key    = "state.tf"
    region = "us-east-1"
    acl    = "private"
    dynamodb_table = "terraform-state-lock-dynamo"
   }
 }

provider "aws" {
  region  = "us-east-1"
  profile = "dev-mfa" //PROFILE
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

provider "local" {
  version = "~> 1.2"
}

locals {
  default_tags = {
    Environment = "staging"
    Owner       = "DevOps"  
    Service     = "EKS"
  }
  name = "rewind-test-k8s"
}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}