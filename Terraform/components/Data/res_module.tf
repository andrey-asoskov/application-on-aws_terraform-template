data "aws_caller_identity" "current" {}

module "Data" {
  source = "../../modules/Data"

  env                                 = var.env
  solution                            = var.solution
  solution_short                      = var.solution_short
  db_backup_retention_period          = lookup(var.db_backup_retention_period, var.env)
  db_enabled_cloudwatch_logs_exports  = var.db_enabled_cloudwatch_logs_exports
  db_instance_class                   = var.db_instance_class
  db_name                             = var.db_name
  db_password_ciphertext              = lookup(var.db_password_ciphertext, var.env)
  db_shutoff                          = lookup(var.db_shutoff, var.env)
  db_skip_final_snapshot              = var.db_skip_final_snapshot
  db_username                         = var.db_username
  db_deletion_protection              = lookup(var.db_deletion_protection, var.env)
  db_engine_version                   = var.db_engine_version
  sec_inventory_bucket                = var.sec_inventory_bucket
  sec_inventory_prefix                = "${var.sec_inventory_prefix}/${data.aws_caller_identity.current.account_id}"
  subnets_private_ids                 = data.terraform_remote_state.VPC.outputs.subnets_private_ids
  r53_zone_id                         = data.terraform_remote_state.VPC.outputs.r53_zone_id
  kms_key_arn                         = data.terraform_remote_state.VPC.outputs.kms_key_arn
  kms_alias_id                        = data.terraform_remote_state.VPC.outputs.kms_alias_id
  kms_alias_arn                       = data.terraform_remote_state.VPC.outputs.kms_alias_arn
  sg_DataDB_id                        = data.terraform_remote_state.VPC.outputs.sg_DataDB_id
  rds_insights_enabled                = lookup(var.rds_insights_enabled, var.env)
  rds_insights_retention_period       = lookup(var.rds_insights_retention_period, var.env)
  hs_password_ciphertext              = lookup(var.hs_password_ciphertext, var.env)
  HS_OIDC_RP_CLIENT_SECRET_ciphertext = lookup(var.HS_OIDC_RP_CLIENT_SECRET_ciphertext, var.env)
}
