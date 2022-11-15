locals {
  codebuild = "${local.name}-code-build"
}

#customer role

resource "aws_iam_role" "codebuild_service_role" {
  name = "${local.name}-codebuild-iam-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "code-build-role-policy" {
  role = aws_iam_role.codebuild_service_role.name
  name = "${local.name}-codebuild-S3-iam-policy"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:GetResourcePolicy",
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "secretsmanager:ListSecretVersionIds",
        "secretsmanager:ListSecrets"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_codebuild_project" "codebuild" {

  name          = local.codebuild
  description   = "Code build for ${local.name}"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_service_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DB_CLIENT"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_CLIENT"
    }
    environment_variable {
      name  = "DB_HOST"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_HOST"
    }
    environment_variable {
      name  = "DB_PORT"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_PORT"
    }
    environment_variable {
      name  = "DB_NAME"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_NAME"
    }
    environment_variable {
      name  = "DB_USER"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_USER"
    }
    environment_variable {
      name  = "DB_PASS"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:DB_PASS"
    }
    environment_variable {
      name  = "GOOGLE_CLIENT_ID"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:GOOGLE_CLIENT_ID"
    }
    environment_variable {
      name  = "GOOGLE_CLIENT_SECRET"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:GOOGLE_CLIENT_SECRET"
    }
    environment_variable {
      name  = "FACEBOOK_CLIENT_ID"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:FACEBOOK_CLIENT_ID"
    }
    environment_variable {
      name  = "FACEBOOK_CLIENT_SECRET"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:FACEBOOK_CLIENT_SECRET"
    }
    environment_variable {
      name  = "AWS_REGION"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:AWS_REGION"
    }
    environment_variable {
      name  = "AWS_ACCESS_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:AWS_ACCESS_KEY"
    }
    environment_variable {
      name  = "AWS_SECRET_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:AWS_SECRET_KEY"
    }
    environment_variable {
      name  = "API_URL"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:API_URL"
    }
    environment_variable {
      name  = "GAMES_URL"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:GAMES_URL"
    }
    environment_variable {
      name  = "STATIC_URL"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:STATIC_URL"
    }
    environment_variable {
      name  = "SENTRY_DSN"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:SENTRY_DSN"
    }
    environment_variable {
      name  = "SENTRY_TRACE_SAMPLE_RATE"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:SENTRY_TRACE_SAMPLE_RATE"
    }
    environment_variable {
      name  = "SES_EMAIL"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:SES_EMAIL"
    }
    environment_variable {
      name  = "SES_FROM"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:SES_FROM"
    }
    environment_variable {
      name  = "ACCESS_TOKEN_DURATION"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:ACCESS_TOKEN_DURATION"
    }
    environment_variable {
      name  = "REFRESH_TOKEN_DURATION"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:REFRESH_TOKEN_DURATION"
    }
    environment_variable {
      name  = "ACCESS_TOKEN_SECRET_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:ACCESS_TOKEN_SECRET_KEY"
    }
    environment_variable {
      name  = "REFRESH_TOKEN_SECRET_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:REFRESH_TOKEN_SECRET_KEY"
    }
    environment_variable {
      name  = "STAGE"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:STAGE"
    }

    environment_variable {
      name  = "APPLE_BUNDLE_ID"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:APPLE_BUNDLE_ID"
    }

    environment_variable {
      name  = "FCM_SERVER_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:FCM_SERVER_KEY"
    }

    environment_variable {
      name  = "CRON_AUTHORIZATION_TOKEN"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:CRON_AUTHORIZATION_TOKEN"
    }

    environment_variable {
      name  = "MAILJET_API_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:MAILJET_API_KEY"
    }

    environment_variable {
      name  = "MAILJET_SECRET_KEY"
      type  = "SECRETS_MANAGER"
      value = "${aws_secretsmanager_secret.api.arn}:MAILJET_SECRET_KEY"
    }

  }


  logs_config {
    cloudwatch_logs {
      group_name  = "${local.name}-code-build-log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.codebuild-S3.id}/build-log"
    }
  }

  source {
    buildspec       = data.local_file.buildspec_local.content
    type            = "CODEPIPELINE"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = true
    }
  }

  tags = {
    Name = local.codebuild
  }
  
}
