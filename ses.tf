resource "aws_iam_user" "ses_user" {
  name = "ses"
  tags = {
    name = "ses"
  }
}

resource "aws_iam_user_policy" "ses_policy" {
  user = aws_iam_user.ses_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ses:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_access_key" "ses_keys" {
  user = aws_iam_user.ses_user.name
}
