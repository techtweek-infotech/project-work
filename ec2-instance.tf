locals {
  userdata = <<-USERDATA
#!bin/bash
apt-get update
USERDATA
}

module "instance-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${local.name}-sg"
  description = "Security group for ec2 instance"

  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = {
   Name = "${local.name}-sg"
}
 
}

module "key-pair" {
  source             = "terraform-aws-modules/key-pair/aws"
  version            = "2.0.0"
  key_name           = var.ec2-instance.key_name
  create_private_key = true
}

module "ec2-instance" {
  source = "cloudposse/ec2-autoscale-group/aws"

  name                        = "${local.name}-ec2-asg"
  image_id                    = var.ec2-instance.ami
  subnet_ids                  = [element(module.vpc.private_subnets, 0)]
  instance_type               = var.ec2-instance.instance_type
  key_name                    = module.key-pair.key_pair_name
  security_group_ids          = [module.instance-sg.security_group_id]
  associate_public_ip_address = true
  block_device_mappings = [
    {
      device_name  = "/dev/sda1"
      no_device    = "false"
      virtual_name = "root"
      ebs = {
        volume_type           = var.ec2-instance.volume_type
        volume_size           = var.ec2-instance.volume_size
        encrypted             = var.ec2-instance.encrypted
        delete_on_termination = true
        iops                  = null
        kms_key_id            = null
        snapshot_id           = null
      }
    }
  ]
  health_check_type                      = "EC2"
  target_group_arns                      = module.alb.target_group_arns
  max_size                               = var.ec2-instance.max_size
  min_size                               = var.ec2-instance.min_size
  desired_capacity                       = var.ec2-instance.desired_capacity
  autoscaling_policies_enabled           = var.ec2-instance.autoscaling_policies_enabled
  cpu_utilization_high_threshold_percent = var.ec2-instance.cpu_utilization_high_threshold_percent
  cpu_utilization_low_threshold_percent  = var.ec2-instance.cpu_utilization_low_threshold_percent
  user_data_base64                       = base64encode(local.userdata)
  iam_instance_profile_name              = aws_iam_instance_profile.main.name
  
  tags = {
   Name = "${local.name}-ec2-asg"
}
 
}
