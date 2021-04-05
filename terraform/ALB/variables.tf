variable "environment" {
  description = "Name of the environment Dev/Prod/Pre-Prod etc."
}
variable "instance_list" {
  type = list(string)
  description = "EKS worker nodes instance ids to attach to target group"
}
variable "owner" {
  description = "Name of the owner of the service"
}
variable "service" {
  description = "Name of the AWS resource i.e. Application Load balancer"
}
variable "domain_name" {
  description = "Domain Name"
}
variable "associated_lb" {
  description = "Name of the associated load balancer for the target group"
}
variable "listener_rule_host" {
  description = "Host header for the listener rule e.g *.rewind.dev"
}
variable "cluster_name" {
  description = "Name of the k8s cluster associated with ALB"
}

variable "route53_record_name" {
  description = "Route53 record name to be assocaited with ALB"
}
variable "eks_sg_cidr_blocks" {
  description = "CIDR block for EKS security group Inbound rule for TCP 31000 and All Traffic protocol (e.g. VPC CIDR block)"
}
variable "internet_sg_cidr_blocks" {
  description = "HTTP and HTTPS CIDR blocks for internet access to ALB"
}

variable "sg_name" {
  description = "Name of the security group associated with ALB"
}

variable "vpc_id" {
  description = "VPC ID in which the ALB needs to be created"
}

variable "alb_name" {
  description = "Name of the ALB"
}

variable "internal_alb" {
  description = "ALB is Internal or internet-facing"
}

variable "alb_subnets" {
  description = "Subnets in which ALB needs to exist"
}

variable "http_listener_protocol" {
  description = "HTTP listener protocol"
}

variable "http_listener_port" {
  description = "HTTP listener port"
}

variable "https_listeners_port" {
  description = "https listener port"
}

variable "https_listeners_protocol" {
  description = "Protocol for https listener"
}

variable "certificate_domain" {
  description = "Domain of the Certificate to be attached to the ALB (Look inside ACM in AWS console)"
}


variable "ssl_policy" {
  description = "The name of the SSL Policy for the listener"
}

variable "target_group_name" {
  description = "Name of the target group"
}
variable "svc_port" {
  description = "Target group's service port"
}
variable "target_group_path" {
  description = "Path to be used for target group's health check"
}
variable "target_group_port" {
  description = "Port for target group"
}

variable "priority" {
  description = "Priority (in number) of the listener rule"
}
variable "target_group_sticky" {
  description = "Enable stickiness on ALB - true|false"
}
variable "eks_sg1" {
  description = "1 of 2 SG for EKS applied on this ALB"
}
variable "eks_sg2" {
  description = "2 of 2 SG for EKS applied on this ALB"
}