variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_instance_type" {
  description = "AWS instance type to launch EC2"
  type        = string
}

variable "aws_subnet_id" {
  description = "AWS subnet to launch EC2"
  type        = string
}

variable "aws_security_group_id" {
  description = "AWS security group ID to launch EC2"
  type        = string
}

variable "aws_iam_instance_profile_name" {
  description = "AWS Instance Profile Name to launch EC2"
  type        = string
}

variable "aws_vpc_id" {
  description = "AWS VPC to launch EC2"
  type        = string
}

variable "aws_kms_key_id" {
  description = "AWS KMS key ID to launch EC2"
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

variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "env_type" {
  description = "Type of an environment"
  type        = string
}

variable "app_version" {
  description = "Version of app"
  type        = string
}

variable "component" {
  description = "Component of app"
  type        = string
}
