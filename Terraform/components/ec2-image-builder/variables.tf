variable "aws_region" {
  description = "AWS region to launch servers."
  type        = string
}

variable "aws_account_type" {
  description = "Type of AWS account"
  type        = string
}

variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "product_id" {
  description = "Product ID of a solution"
  type        = string
}

/*variable "s3_ansible_URI" {
  type        = string
  description = "S3 URI for Ansible"
}*/

/*variable "app_version" {
  description = "Version of app Forms"
  type        = string
}*/
