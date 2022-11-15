module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name                = "${local.name_alb}-sg"
  description         = "${local.name_alb}-sg"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = var.alb_sg.ingress_cidr_blocks
  ingress_rules       = var.alb_sg.ingress_rules
  egress_cidr_blocks  = var.alb_sg.egress_cidr_blocks
  egress_rules        = var.alb_sg.egress_rules
     
  tags = {
   Name = "${local.name_alb}-sg"
}
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name                       = local.name_alb
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = var.environment == "dev" ? false : true
  vpc_id                     = module.vpc.vpc_id
  subnets                    = module.vpc.public_subnets
  security_groups            = [module.alb_sg.security_group_id]

  target_groups = [
    {
      name             = "${local.name_tg}"
      backend_protocol = "HTTP"
      target_type      = "instance"
      backend_port     = "80"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/nginx-health"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      target_group_index = 0
    }
  ]
     
  tags = {
   Name = local.name_alb
}
}

module "alb_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  providers = {
    aws = aws.root
  }
  zone_id = data.aws_route53_zone.this.zone_id

  records = [
    {
      name = "${var.environment}-api.${var.type}"
      type = "A"
      alias = {
        name    = module.alb.lb_dns_name
        zone_id = module.alb.lb_zone_id
      }
    }
  ]

}
