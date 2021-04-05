#### ALB resource #####
resource "aws_alb" "alb" {
  name            = var.alb_name
  subnets         = var.alb_subnets
  security_groups = [aws_security_group.alb_eks_sg.id,aws_security_group.alb_http_https_sg.id,var.eks_sg1,var.eks_sg2]
  internal        = var.internal_alb
  tags            = local.default_tags
}
#### Security Group for EKS Access #####
resource "aws_security_group" "alb_eks_sg" {
  name_prefix = var.sg_name
  vpc_id      = var.vpc_id

  ingress {
    from_port = 31000
    to_port   = 31000
    protocol  = "tcp"
    description = "Inbound rule for ${var.cluster_name} cluster"
    cidr_blocks = var.eks_sg_cidr_blocks
  }
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = var.eks_sg_cidr_blocks
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##### Security Group for Internet Access #####
resource "aws_security_group" "alb_http_https_sg" {
  name_prefix = var.sg_name
  vpc_id      = var.vpc_id

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = var.internet_sg_cidr_blocks
  }
}
#### Target Group #####

resource "aws_alb_target_group" "alb_target_group" {
  name     = var.target_group_name
  port     = var.svc_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = var.target_group_sticky
  }
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    matcher             = "200-499"
    path                = var.target_group_path
    port                = var.target_group_port
  }
}

#### Target group attachment #####
resource "aws_alb_target_group_attachment" "target_group_attachment" {
  count            = length(var.instance_list)
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = var.instance_list[count.index]
  port             = 80
}

#### ALB HTTP Listener #####
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.http_listener_port
  protocol          = var.http_listener_protocol

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

#### Self Signed certificate #####
resource "tls_self_signed_cert" "self_signed" {
  key_algorithm   = "ECDSA"
  private_key_pem = "${file("private_rewind.dev.key")}"

  subject {
    common_name  = "rewind.dev"
    organization = "Rewind"
  }

  validity_period_hours = 12

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}


##### ALB HTTPS Listener #####
resource "aws_alb_listener" "https_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = var.https_listeners_port
  protocol          = var.https_listeners_protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = data.tls_self_signed_cert.self_signed.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "No authorization to access this site"
      status_code  = "503"
    }
  }
}

##### Listener Rule ##### {More listener rules can be created similarly if required}
resource "aws_alb_listener_rule" "https_listener_rule" {
  listener_arn = aws_alb_listener.https_listener.arn
  priority     = var.priority
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
  condition {
    host_header  {
      values = var.listener_rule_host
    }
  }
}

#### Route53 CNAME Record for ALB #####
resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = var.route53_record_name 
  type    = "CNAME"
  ttl     = "60"
  records = [aws_alb.alb.dns_name]
}
