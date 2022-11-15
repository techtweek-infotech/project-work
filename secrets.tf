locals {
  client = jsondecode(data.aws_secretsmanager_secret_version.values.secret_string)
  secrets = {
    DB_CLIENT = "pg"
    DB_HOST   = module.db.db_instance_address
    DB_PORT   = module.db.db_instance_port
    DB_NAME   = module.db.db_instance_name
    DB_USER   = module.db.db_instance_username
    DB_PASS   = module.db.db_instance_password

    GOOGLE_CLIENT_ID         = local.client.CORE_DEV_GOOGLE_CLIENT_ID
    GOOGLE_CLIENT_SECRET     = local.client.CORE_DEV_GOOGLE_CLIENT_SECRET
    FACEBOOK_CLIENT_ID       = local.client.CORE_DEV_FACEBOOK_CLIENT_ID
    FACEBOOK_CLIENT_SECRET   = local.client.CORE_DEV_FACEBOOK_CLIENT_SECRET
    APPLE_BUNDLE_ID          = local.client.CORE_DEV_APPLE_BUNDLE_ID
    FCM_SERVER_KEY           = local.client.CORE_DEV_FCM_SERVER_KEY
    CRON_AUTHORIZATION_TOKEN = local.client.CORE_DEV_CRON_AUTHORIZATION_TOKEN
    MAILJET_API_KEY          = local.client.CORE_DEV_MAILJET_API_KEY
    MAILJET_SECRET_KEY       = local.client.CORE_DEV_MAILJET_SECRET_KEY
    ACCESS_TOKEN_DURATION    = local.client.CORE_DEV_ACCESS_TOKEN_DURATION
    REFRESH_TOKEN_DURATION   = local.client.CORE_DEV_REFRESH_TOKEN_DURATION
    ACCESS_TOKEN_SECRET_KEY  = local.client.CORE_DEV_ACCESS_TOKEN_SECRET_KEY
    REFRESH_TOKEN_SECRET_KEY = local.client.CORE_DEV_REFRESH_TOKEN_SECRET_KEY
    SENTRY_DSN               = local.client.CORE_DEV_SENTRY_DSN
    SENTRY_TRACE_SAMPLE_RATE = local.client.CORE_DEV_SENTRY_TRACE_SAMPLE_RATE

    AWS_REGION     = var.region
    AWS_ACCESS_KEY = aws_iam_access_key.ses_keys.id
    AWS_SECRET_KEY = aws_iam_access_key.ses_keys.secret

    API_URL    = "https://${var.environment}-core.${var.type}.${var.domain_name}"
    GAMES_URL  = "https://${var.environment}-static.${var.type}.${var.domain}"
    STATIC_URL = "https://${var.environment}-static.${var.type}.${var.domain_name}"


    SES_EMAIL = var.ses_email
    SES_FROM  = var.ses_from
    STAGE     = var.environment

  }
}

resource "aws_secretsmanager_secret" "api" {
  name                    = local.name_secret
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "version" {
  secret_id     = aws_secretsmanager_secret.api.id
  secret_string = jsonencode(local.secrets)
}
