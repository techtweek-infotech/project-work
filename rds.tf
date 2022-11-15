resource "aws_db_subnet_group" "subnet_group" {
  name        = "${local.name_database}-subnet-group"
  description = var.db_subnet_group_description
  subnet_ids  = module.vpc.database_subnets
       
  tags = {
   Name = "${local.name_database}-subnet-group"
}
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier           = local.name_database
  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class
  #snapshot_identifier = var.snapshot_identifier #Remove comment when db is deployed from snapshot

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = module.kms_key_core.key_arn

  name                   = var.environment
  username               = var.username
  port                   = var.port
  create_random_password = var.random_password_enabled
  random_password_length = var.random_password_length

  multi_az               = var.multi_az
  vpc_security_group_ids = [module.rds_sg.security_group_id]
  create_db_subnet_group = var.create_db_subnet_group
  db_subnet_group_name   = module.vpc.database_subnet_group

  subnet_ids                      = module.vpc.database_subnets
  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval

  create_db_option_group    = false # default
  create_db_parameter_group = false # default
     
  tags = {
   Name = local.name_database
}
}

module "rds_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.8.0"

  name        = "${local.name_database}-sg"
  description = "RDS security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "Dev core vpc cidr block"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
    {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      description = "Root vpc cidr block for private connection"
      cidr_blocks =  var.root_vpc_cidr_block
    }
  ]
     
  tags = {
   Name = "${local.name_database}-sg"
}
}

resource "aws_db_instance_automated_backups_replication" "rds_backup" {

  source_db_instance_arn = module.db.db_instance_arn
  kms_key_id             = aws_kms_replica_key.replica.arn
  provider               = aws.rds_backup

}
