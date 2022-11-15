# Tags
variable "project" {}

variable "dev_account" {
  type = string
}

variable "name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "project environment"
  type        = string
}

variable "type" {
  description = "project type"
  type        = string
}

variable "function" {
  description = "project function"
  type        = string
}

variable "region" {
  description = "project region"
  type        = string
}

variable "rds_backup_region" {
  description = "Region for RDS backup accross differnet region"
  type        = string
}

variable "aws_region" {
  description = "project region"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc_cidr"
  type        = string
}

variable "domain_name" {
  description = "project domain_name"
  type        = string
}

variable "ns_records_enabled" {
  type        = bool
  description = "Enable and add NS records in mgmt account - root zone"
}

variable "ec2-instance" {
  description = "ec2 instance"
  type        = any
}

# ALB
variable "alb_sg" {
  description = "ALB security group variables"
  type        = any
}

## Database

variable "engine" {
  description = "Database engine to use for aws rds"
  type        = string
}

variable "engine_version" {
  description = "Database engine version to use for aws rds"
  type        = string
}

variable "family" {
  description = "Database family version to use for aws rds"
  type        = string
}

variable "major_engine_version" {
  description = "Database major engine version to use for aws rds"
  type        = string
}

variable "instance_class" {
  description = "Instance class of database instance"
  type        = string
}

variable "root_vpc_cidr_block" {
  description = "root cidr block "
  type        = string
}

variable "peer_dns_resolution" {
  description = "Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a peer VPC"
  type        = bool
}

variable "this_dns_resolution" {
  description = "Indicates whether a local VPC can resolve public DNS hostnames to private IP addresses when queried from instances in a this VPC"
  type        = bool
}

#uncomment this when rds is deployed from snapshot
/*
variable "snapshot_identifier" {
  description = "snapshot identifier of database instance"
  type        = string
}
*/

variable "allocated_storage" {
  description = "Allocated storage for rds instance"
  type        = number
}

variable "max_allocated_storage" {
  description = "Max allocated storage for rds instance"
  type        = number
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = number
}

variable "random_password_enabled" {
  description = "random_password_enabled"
  type        = bool
}

variable "random_password_length" {
  description = "random_password_length"
  type        = number
}

variable "multi_az" {
  type        = bool
  description = "multi_az"
}

variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
}

variable "maintenance_window" {
  type        = string
  description = "RDS maintenance window"
}

variable "backup_window" {
  type        = string
  description = "RDS backup window"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported."
  type        = list(string)
  default     = []
}

variable "backup_retention_period" {
  type        = number
  description = "RDS backup retention period"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "RDS skip final snapshot"
}

variable "deletion_protection" {
  type        = bool
  description = "RDS deletion protection"
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
}

variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = bool
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
}

variable "db_subnet_group_description" {
  description = "Description of the DB subnet group to create"
  type        = string
}

## guardduty ##

variable "create_sns_topic" {
  description = "Whether SNS topic will be created"
  type        = string
}

variable "sns_topic_name" {
  description = "SNS topic where GuardDuty Alerts will be sent"
  type        = string
}

variable "guardduty_subscription_protocol" {
  description = "Protocol for the GuardDuty SNS notifications"
}

variable "guardduty_notification_endpoint" {
  description = "Endpoint for the GuardDuty SNS notifications"
}

variable "guardduty_enabled" {
  description = "Enable guardduty"
}

variable "kms_key" {
  description = "kms-key for resources encryption"
  type        = any

}

variable "codestar-connection" {
  description = "kms-key for resources encryption"
  type        = any

}

#ssl
variable "domain" {
  description = "Domain name"
  type        = string
}

variable "core-domain" {
  description = "core domain name"
  type        = string
}

variable "abbott-domain" {
  description = "abbott domain name"
  type        = string
}
variable "api_logs_metric_name" {
  type = string
}

variable "static_logs_metric_name" {
  type = string
}

variable "api-log" {
  type = string
}

variable "static-log" {
  type = string
}

variable "recovery_window" {
  default = "14"
}

variable "ses_email" {
  type    = string
# default = "no-reply@mysquegg.com"
}

variable "ses_from" {
  type    = string
#  default = "Squegg"
}