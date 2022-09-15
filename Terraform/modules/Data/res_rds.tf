resource "aws_db_subnet_group" "db" {
  name        = "${var.solution}-${var.env}-db"
  description = "Database subnet group for ${var.solution} - ${var.env}"
  subnet_ids  = var.subnets_private_ids

  tags = {
    Name = "${var.solution}-${var.env}-db_subnet_group"
  }
}

resource "aws_db_parameter_group" "hs" {
  name        = "${var.solution}-${var.env}-db-parameter-group"
  family      = "postgres12"
  description = "DB parameter group for ${var.solution}-${var.env}"

  parameter {
    name  = "log_min_duration_statement"
    value = "60000"
  }

  parameter {
    name  = "log_statement"
    value = "ddl"
  }

  parameter {
    name  = "log_statement_stats"
    value = "0"
  }

  parameter {
    name  = "rds.force_ssl"
    value = "1"
  }

  tags = {
    Name = "${var.solution}-${var.env}-db_parameter_group"
  }
}

resource "aws_db_instance" "db" {
  apply_immediately                     = true
  allocated_storage                     = 200
  max_allocated_storage                 = 400
  auto_minor_version_upgrade            = true
  copy_tags_to_snapshot                 = true
  delete_automated_backups              = false
  iam_database_authentication_enabled   = true
  backup_retention_period               = var.db_backup_retention_period #checkov:skip=CKV_AWS_133:Ensure that RDS instances has backup policy
  backup_window                         = "01:00-02:00"
  maintenance_window                    = "Sun:03:00-Sun:04:00"
  db_subnet_group_name                  = aws_db_subnet_group.db.name
  deletion_protection                   = var.db_deletion_protection
  enabled_cloudwatch_logs_exports       = var.db_enabled_cloudwatch_logs_exports
  engine                                = "postgres"
  engine_version                        = var.db_engine_version
  identifier                            = "${var.solution}-${var.env}-db-instance"
  instance_class                        = var.db_instance_class
  kms_key_id                            = var.kms_key_arn
  multi_az                              = "true"
  db_name                               = var.db_name
  password                              = jsondecode(aws_secretsmanager_secret_version.secret-version.secret_string)["FORMS_DB_PASS"]
  publicly_accessible                   = false
  skip_final_snapshot                   = var.db_skip_final_snapshot
  storage_encrypted                     = true
  username                              = var.db_username
  vpc_security_group_ids                = [var.sg_DataDB_id]
  monitoring_interval                   = 5
  monitoring_role_arn                   = aws_iam_role.RDS_enhanced_monitoring.arn
  parameter_group_name                  = aws_db_parameter_group.hs.name
  performance_insights_enabled          = var.rds_insights_enabled
  performance_insights_kms_key_id       = var.kms_key_arn
  performance_insights_retention_period = var.rds_insights_retention_period
  #snapshot_identifier = var.db_snapshot

  depends_on = [
    aws_cloudwatch_log_group.db
  ]

  tags = {
    Name    = "${var.solution}-${var.env}-db-instance"
    shutOff = var.db_shutoff
  }
}
