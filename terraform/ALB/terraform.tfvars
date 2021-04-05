sg_name                         = "rewind-test-alb-sg"
instance_list                   = [""]
vpc_id                          = "" // Update the VPC ID 
eks_sg1                         = "" // Update EKS CLuster Security Group 1
eks_sg2                         = "" // Update EKS CLuster Security Group 2
alb_name                        = "rewind-test-alb"
internal_alb                    = false
alb_subnets                     = [""] // Update ALB private subnets
http_listener_port              = 80
http_listener_protocol          = "HTTP"
https_listeners_port            = 443
https_listeners_protocol        = "HTTPS"
ssl_policy                      = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
target_group_name               = "tg-rewind-test"
svc_port                        = "31000"
target_group_path               = "/"
target_group_port               = "traffic-port"
priority                        = 100
target_group_sticky             = false
environment                     = "staging"
owner                           = "DevOps"
service                         = "ALB"
domain_name                     = "rewind.dev"
listener_rule_host              = ["xxx.rewind.dev"]
route53_record_name             = "*.rewind.dev"
internet_sg_cidr_blocks         = [ "0.0.0.0/0" ]
eks_sg_cidr_blocks              = [ "" ] // Update EKS Security Cidr Range
cluster_name                    = "rewind-test-k8s"
associated_lb                   = "rewin-test-alb"