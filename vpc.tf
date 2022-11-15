module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.12.0"

  name             = "${local.name}-vpc"
  cidr             = var.vpc_cidr
  azs              = ["${var.region}a", "${var.region}b"]
  private_subnets  = [cidrsubnet(var.vpc_cidr, 7, 1), cidrsubnet(var.vpc_cidr, 7, 2)]
  public_subnets   = [cidrsubnet(var.vpc_cidr, 7, 3), cidrsubnet(var.vpc_cidr, 7, 4)]
  database_subnets = [cidrsubnet(var.vpc_cidr, 7, 5), cidrsubnet(var.vpc_cidr, 7, 6)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  enable_vpn_gateway = false

  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60

  manage_default_vpc            = false
  default_vpc_tags              = { Name = "${local.name}-default" }
  manage_default_network_acl    = false
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = false
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = false
  default_security_group_tags   = { Name = "${local.name}-default" }

  tags = {
   Name = "${local.name}-vpc"
}

}

