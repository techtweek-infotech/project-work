locals {

  account_id      = data.aws_caller_identity.current.account_id
  region          = data.aws_region.current.name
  name            = format("%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function)
  name_codestar   = format("%s-%s", var.environment, var.aws_region)
  name_database   = format("%s-%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function, "rds")
  name_alb        = format("%s-%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function, "alb")
  name_tg         = format("%s-%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function, "tg")
  name_s3         = format("%s-%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function, "s3")
  name_cloudwatch = format("%s-%s-%s-%s-%s", var.environment, var.aws_region, var.type, var.function, "cloudwatch")
  name_secret     = join("/", ["${var.name}", var.environment, "api"])


}
