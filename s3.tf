#cloudfront bucket

module "s3_one" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket        = "${local.name_s3}-static-bucket"
  force_destroy = true
  acl           = "private"
  
  tags = {
   Name = "${local.name_s3}-static-bucket"
}
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_one.s3_bucket_arn}/*"]

    principals {
      type        = "AWS"
      identifiers = module.cdn.cloudfront_origin_access_identity_iam_arns
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3_one.s3_bucket_id
  policy = data.aws_iam_policy_document.s3_policy.json
}

#codepipeline bucket

resource "aws_s3_bucket" "pipeline" {
  bucket = "${local.name}-codepipeline-bucket"
  
  server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
       kms_master_key_id = module.kms_key_core.key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${local.name}-Codepipeline",
  "Statement": [
        {
            "Sid": "DenyUnEncryptedObjectUploads",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${local.name}-codepipeline-bucket/*",
            "Condition": {
                "StringNotEquals": {
                    "s3:x-amz-server-side-encryption": "aws:kms"
                }
            }
        },
        {
            "Sid": "DenyInsecureConnections",
            "Effect": "Deny",
            "Principal": "*",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${local.name}-codepipeline-bucket/*",
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY

  tags = {
   Name = "${local.name}-codepipeline-bucket"
}
}

#codebuild bucket

resource "aws_s3_bucket" "codebuild-S3" {
  bucket        = "${local.name}-codebuild-bucket"
  force_destroy = true

  server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = module.kms_key_core.key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

  tags = {
   Name = "${local.name}-codebuild-bucket"
}
}

resource "aws_s3_bucket_acl" "codebuild-S3" {
  bucket = aws_s3_bucket.codebuild-S3.id
  acl    = "private"
}

