resource "aws_backup_region_settings" "backup-main" {
  resource_type_opt_in_preference = {
    "EBS"             = true
    "EC2"             = true
    "RDS"             = true
    "Aurora"          = false
    "DynamoDB"        = false
    "EFS"             = false
    "FSx"             = false
    "Storage Gateway" = false
    "DocumentDB"      = false
    "Neptune"         = false
    "VirtualMachine"  = false
    "S3"              = false
  }
}

resource "aws_backup_vault" "backup-vault-main" {
  name        = "${var.solution_short}-backup_vault"
  kms_key_arn = aws_kms_key.region-key.arn

  tags = {
    Name = "${var.solution_short}-backup_vault"
  }
}

resource "aws_backup_plan" "backup-plan-main" {
  name = "${var.solution_short}-backup_plan"

  rule {
    rule_name         = "backup_rule"
    target_vault_name = aws_backup_vault.backup-vault-main.name
    schedule          = "cron(30 0 * * ? *)"
  }

  tags = {
    Name = "${var.solution_short}-backup_plan"
  }
}

resource "aws_backup_selection" "backup-main" {
  iam_role_arn = var.backup_role_arn
  name         = "${var.solution_short}-backup_selection"
  plan_id      = aws_backup_plan.backup-plan-main.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Backup"
    value = "true"
  }
}
