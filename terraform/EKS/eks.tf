data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v12.2.0"
  cluster_name = var.cluster_name
  cluster_version = var.cluster_version
  cluster_endpoint_private_access = true
  subnets      = var.subnets
  tags         = local.default_tags
  vpc_id       = var.vpc_id
   

  node_groups_defaults = {
    ami_type  = var.ami_type 
    # reference  https://docs.aws.amazon.com/eks/latest/userguide/create-managed-node-group.html
    disk_size = var.disk_size
    key_name   = var.ssh_key_name
    source_security_group_ids = var.source_security_group_ids
  }

  node_groups = {
    first_group = {
      name = var.node_group_name
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type = var.instance_type
      k8s_labels = {
        Environment = var.environment
        GithubRepo  = "terraform-aws-eks"
        GithubOrg   = "terraform-aws-modules"
      }
    
    }
  }
  map_roles                            = var.map_roles
  map_users                            = var.map_users
}
