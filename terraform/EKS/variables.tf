variable "vpc_id" {
  description = "ID of the VPC in whioch EKS cluster needs to be created"
}
variable "ami_type" {
}
variable "disk_size" {
}
variable "ssh_key_name" {
}
variable "node_group_name" {}
variable "source_security_group_ids" {}
variable "environment" {}
variable "cluster_name" {
  description = "Name of the EKS cluster"
}
variable "subnets" {
  description = "Private subnets associated with the cluster"
}
# variable "worker_group_name" {
#   description = "Name of the worker group"
# }
variable "alb_tg_arns" {
  description = "arns of ALB target group that connects to EKS cluster"
}
variable "instance_type" {
  description = "Instance type of the workergroup ec2 instance"
}
variable "desired_capacity" {
  description = "Desired capacity of v nodes"
}
variable "max_capacity" {
  description = "Max number of v nodes"
}

variable "min_capacity" {
  description = "Minimum number of v nodes"
}

# variable "key_name" {
#   description = "Name of the key to be used to SSH into ec2 nodes"
# }
# variable "key_algo" {
#   description = "Algorithm used to generate the SSH key"
# }
# variable "key_bits" {
#   description = "Size of the key"
# }
variable "cluster_version" {
  description = "Version of the EKS cluster to install"
}
variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "cloudwatch_policy_arn" {
  
}

# variable "ami_type" {
#   description = "AMI image type"
# }