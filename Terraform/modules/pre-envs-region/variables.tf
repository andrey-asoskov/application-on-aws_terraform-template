variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "aws_account_type" {
  description = "Type of AWS account"
  type        = string
}

variable "backup_role_arn" {
  description = "IAM Role ARN for Backup"
  type        = string
}

variable "new_relic_api_key_ciphertext" {
  description = "NR API key (Encrypted)"
  type        = string
}
