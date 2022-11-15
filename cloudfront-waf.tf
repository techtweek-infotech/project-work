module "cloudfront_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = var.static-log
  retention_in_days = 3
  tags = {
    Name = var.static-log
  }
  
}

module "aws-cf-waf-acl" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.8.1"
  # insert the 2 required variables here

  name_prefix            = "${local.name}-cf-waf"
  scope                  = "CLOUDFRONT"
  create_alb_association = false
  allow_default_action   = true
  tags = {
    Name = "${local.name}-cf-waf"
  }
  create_logging_configuration = true
  log_destination_configs      = [module.cloudfront_log_group.cloudwatch_log_group_arn]
  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = var.static_logs_metric_name
    sampled_requests_enabled   = true
  }
  rules = [
    {
      name     = "AWSManagedRulesCommonRuleSet-rule-1"
      priority = "1"

      override_action = "none"

      visibility_config = {
        metric_name = "AWSManagedRulesCommonRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        excluded_rule = [
          "SizeRestrictions_QUERYSTRING",
          "SizeRestrictions_BODY",
          "GenericRFI_QUERYARGUMENTS"
        ]
      }
    }
  ]
}
