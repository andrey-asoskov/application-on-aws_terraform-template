variable "component" {
  description = "Number of the component"
  type        = string
}

variable "organization_name" {
  description = "Number of the TFE organization"
  type        = string
}

variable "workspace_name" {
  description = "Number of the TFE workspace"
  type        = string
}

variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "aws_account_type" {
  description = "Type of AWS account"
  type        = string
}

variable "tf_version" {
  description = "Terraform version"
  type        = string
}
