data "aws_default_tags" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_elb_service_account" "main" {
  region = var.region
}

data "aws_route53_zone" "public-zone" {
  name     = var.domain
  provider = aws.root
}

data "aws_route53_zone" "this" {
  name     = var.domain
  provider = aws.root
}

data "local_file" "buildspec_local" {
    filename = "${path.module}/buildspec.yml"
}

data "aws_secretsmanager_secret" "secret" {
  name = "${var.name}/client/credentials"
}

data "aws_secretsmanager_secret_version" "values" {
  secret_id = data.aws_secretsmanager_secret.secret.id
}

data "aws_secretsmanager_secret" "api-secret" {
  arn = aws_secretsmanager_secret.api.arn
}

data "terraform_remote_state" "root" {
  backend = "remote"

  config = {
    organization = "thebiosprarrow-dev"
    workspaces = {
      name = "squegg-root-infra"
    }
  }
}