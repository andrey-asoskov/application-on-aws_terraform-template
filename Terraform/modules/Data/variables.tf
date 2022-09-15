variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" { # tflint-ignore: terraform_unused_declarations
  description = "Short name of a solution"
  type        = string
}

variable "db_backup_retention_period" {
  description = "DB Backup retention period"
  type        = number
}

variable "db_enabled_cloudwatch_logs_exports" {
  description = "DB enabled cloudwatch logs exports"
  type        = list(any)
}

variable "db_instance_class" {
  description = "DB instance class"
  type        = string
}

variable "db_name" {
  description = "DB name"
  type        = string
}

variable "db_password_ciphertext" {
  description = "DB password (encrypted)"
  type        = string
}

variable "db_shutoff" {
  description = "IF there is a need to shut DB off via automation"
  type        = string
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot"
  type        = bool
}

variable "db_username" {
  description = "username for db connection used by the app"
  type        = string
}

/*variable "db_snapshot" {
  description = "DB snapshot to create the DB"
  type        = string
}*/

variable "db_deletion_protection" {
  description = "Should deletion protection be set"
  type        = string
}

variable "db_engine_version" {
  description = "DB Engine version"
  type        = string
}

variable "sec_inventory_bucket" {
  description = "S3 Bucket for sending inventory to SOC"
  type        = string
}

variable "sec_inventory_prefix" {
  description = "S3 prefix for sending inventory to SOC"
  type        = string
}

variable "subnets_private_ids" {
  type        = list(any)
  description = "Private subnets ids"
}

variable "r53_zone_id" {
  type        = string
  description = "R53 zone ID"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key id"
}

variable "kms_alias_id" {
  type        = string
  description = "KMS Alias id"
}

variable "kms_alias_arn" {
  type        = string
  description = "KMS Alias arn"
}

variable "sg_DataDB_id" {
  type        = string
  description = "Security Group id for DataDB"
}

variable "rds_insights_enabled" {
  type        = bool
  description = "Use or not perf insights"
}

variable "rds_insights_retention_period" {
  type        = number
  description = "Perf Insights retention period"
}

variable "hs_password_ciphertext" {
  description = "HS user password (encrypted)"
  type        = string
}

variable "HS_OIDC_RP_CLIENT_SECRET_ciphertext" {
  description = "OIDC client secret (encrypted)"
  type        = string
}
