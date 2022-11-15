resource "aws_iam_role" "deployment" {
  name = "${local.name}-code-deployment-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codedeploy_policy" {
  name = "codedeploy_policy"
  role = aws_iam_role.deployment.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "ec2:RunInstances",
                "ec2:CreateTags"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.deployment.name
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole1" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.deployment.name
}

resource "aws_codedeploy_app" "deployment" {
  compute_platform = "Server"
  name             = "${local.name}-code-deployment-app"
}

resource "aws_codedeploy_deployment_group" "deployment" {
  app_name               = aws_codedeploy_app.deployment.name
  deployment_group_name  = "${local.name}-code-deployment-group"
  service_role_arn       = aws_iam_role.deployment.arn
  deployment_config_name = "CodeDeployDefault.OneAtATime" # AWS defined deployment config
  autoscaling_groups     = [module.ec2-instance.autoscaling_group_name]
  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }
  load_balancer_info {
    target_group_info {
      name = module.alb.target_group_names[0]
    }
  }

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
    ]
  }

  tags = {
    Name = "${local.name}-code-deployment-group"
  }
  
}
