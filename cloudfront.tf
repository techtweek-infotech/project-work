module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  version                       = "2.9.1"
  aliases                       = ["${var.environment}-static.${var.type}.${var.domain_name}"]
  enabled                       = true
  is_ipv6_enabled               = true
  comment                       = "${var.environment} ${var.type} Cloudfront Distribution for S3 Bucket static"
  retain_on_delete              = false
  wait_for_deployment           = false
  create_origin_access_identity = true
  web_acl_id                    = module.aws-cf-waf-acl.web_acl_assoc_id
  origin_access_identities = {
    s3_bucket_one = "CloudFront can access"
  }

  origin = {

    s3_bucket_one = {

      domain_name = module.s3_one.s3_bucket_bucket_regional_domain_name
      # origin_id   = "${aws_s3_bucket.cloudfront-static-s3-bucket.id}.s3.${var.region}.amazonaws.com"
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }

  }

  default_cache_behavior = {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3_bucket_one"
    compress         = true
    query_string     = false

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400



  }
  geo_restriction = {
    restriction_type = "none"
    locations        = []
  }

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
  tags = {
    Name = "${var.environment}-${var.type}-cf"
  }
  
}


module "cf_records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"
  providers = {
    aws = aws.root
  }
  zone_id = data.aws_route53_zone.this.zone_id
  records = [
    {
      name = "${var.environment}-static.${var.type}"
      type = "A"
      alias = {
        name    = module.cdn.cloudfront_distribution_domain_name
        zone_id = module.cdn.cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}