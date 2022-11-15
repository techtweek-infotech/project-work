module "alb_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = var.api-log
  retention_in_days = 3
  tags = {
  Name = var.api-log
  }
}

module "aws-alb-waf-acl" {
  source  = "umotif-public/waf-webaclv2/aws"
  version = "~> 3.0.0"
  # insert the 2 required variables here

  name_prefix = "${local.name}-alb-waf"
  #region       = var.region
  scope                  = "REGIONAL"
  alb_arn                = module.alb.lb_arn
  create_alb_association = false
  allow_default_action   = true

  create_logging_configuration = true
  log_destination_configs      = [module.alb_log_group.cloudwatch_log_group_arn]
  tags = {
    Name = "${local.name}-alb-waf"
  }

  visibility_config = {
    cloudwatch_metrics_enabled = true
    metric_name                = var.api_logs_metric_name
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
    },
    {
      name     = "AWSManagedRulesKnownBadInputsRuleSet-rule-2"
      priority = "2"

      override_action = "count"

      visibility_config = {
        metric_name = "AWSManagedRulesKnownBadInputsRuleSet-metric"
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "AWSManagedRulesPHPRuleSet-rule-3"
      priority = "3"

      override_action = "none"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "AWSManagedRulesPHPRuleSet-metric"
        sampled_requests_enabled   = false
      }

      managed_rule_group_statement = {
        name        = "AWSManagedRulesPHPRuleSet"
        vendor_name = "AWS"
      }
    },
    {
      name     = "ByteMatchRule-4"
      priority = "4"

      action = "count"

      visibility_config = {
        cloudwatch_metrics_enabled = false
        metric_name                = "ByteMatchRule-metric"
        sampled_requests_enabled   = false
      }

      byte_match_statement = {
        field_to_match = {
          uri_path = "{}"
        }
        positional_constraint = "STARTS_WITH"
        search_string         = "/path/to/match"
        priority              = 0
        type                  = "NONE"
      }
    }
  ]
}
