module "rds-master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.10"

  identifier           = "${local.aws_resource_prefix}-rds-master"
  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = var.environment == "prod" ? "db.m5.4xlarge" : "db.t3.medium"
  publicly_accessible  = false

  allow_major_version_upgrade = true

  storage_type = "io1"

  allocated_storage     = var.environment == "prod" ? 500 : 100
  max_allocated_storage = 1000
  iops                  = var.environment == "prod" ? "2000" : "1000"

  multi_az             = var.environment == "prod"
  db_subnet_group_name = module.vpc.database_subnet_group_name
  port                 = local.port
  username             = "rD$Us3R"
  password             = module.secrets_manager_rds.secret_string

  vpc_security_group_ids = [module.security-group-rds.security_group_id]

  maintenance_window              = "Sun:04:00-Sun:06:00"
  backup_window                   = "06:00-08:00"
  backup_retention_period         = var.environment == "prod" ? 30 : 7
  enabled_cloudwatch_logs_exports = ["general", "audit", "slowquery"]
  create_cloudwatch_log_group     = true

  skip_final_snapshot = true
  deletion_protection = true

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  tags = local.tags

}

module "rds-replica" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.10"

  count = var.environment == "prod" ? 1 : 0

  identifier = "${local.aws_resource_prefix}-rds-replica"

  replicate_source_db = module.rds-master.db_instance_identifier

  multi_az = false

  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = "db.m5.2xlarge"
  publicly_accessible  = false

  storage_type          = "io1"
  allocated_storage     = 500
  max_allocated_storage = 1000
  iops                  = 2000

  allow_major_version_upgrade = true
  deletion_protection         = true

  vpc_security_group_ids = [module.security-group-rds.security_group_id]

  maintenance_window      = "Sun:04:00-Sun:06:00"
  backup_window           = "06:00-08:00"
  backup_retention_period = 30

  performance_insights_enabled          = true
  performance_insights_retention_period = 7

  enabled_cloudwatch_logs_exports = ["general", "audit", "slowquery"]
  create_cloudwatch_log_group     = true

  tags = local.tags

}