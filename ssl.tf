module "acm" {
  source            = "terraform-aws-modules/acm/aws"
  version           = "~> 4.0"
  validation_method = "DNS"
  domain_name       = var.domain
  subject_alternative_names = [
    "*.${var.core-domain}",
  ]
  create_route53_records  = false
  validation_record_fqdns = module.route53_records.validation_route53_record_fqdns
}


module "route53_records" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  providers = {
    aws = aws.root
  }
  
  create_certificate          = false
  create_route53_records_only = true

  distinct_domain_names = module.acm.distinct_domain_names
  zone_id               = data.aws_route53_zone.public-zone.zone_id
  #zone_id              = module.zone.route53_zone_zone_id

  acm_certificate_domain_validation_options = module.acm.acm_certificate_domain_validation_options
}
