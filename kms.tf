module "kms_key_core" {
  source  = "terraform-aws-modules/kms/aws"
  version = "1.2.0"

  description             = "KMS key for encryption"
  aliases                 = ["alias/encrypt"]
  deletion_window_in_days = var.kms_key.deletion_window_in_days
  enable_key_rotation     = var.kms_key.enable_key_rotation
  is_enabled              = var.kms_key.enable
  multi_region            = var.kms_key.multi_region
  policy = templatefile(
    "${path.module}/../../../src/iam/kms.json",
    {
      account_id = local.account_id
    }
  )
    
  tags = {
   Name = "KMS key for encryption"
}
}

resource "aws_kms_replica_key" "replica" {

  description             = "Multi-Region replica key"
  deletion_window_in_days = 7
  primary_key_arn         = module.kms_key_core.key_arn
  provider                = aws.rds_backup

}
