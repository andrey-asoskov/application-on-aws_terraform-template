variable "aws_region" {
  description = "AWS region to spin up the infra"
  type        = map(string)
  default = {
    "dev"     = "us-east-1"
    "dev2"    = "eu-central-1"
    "staging" = "us-east-1"
    "prod"    = "us-east-1"
    "prod-uk" = "eu-west-2"
  }
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

variable "az_count" {
  description = "Number of Availability Zones to use"
  type        = number
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = map(string)

  default = {
    "dev"     = "10.1.0.0/16"
    "dev2"    = "10.5.0.0/16"
    "staging" = "10.2.0.0/16"
    "prod"    = "10.3.0.0/16"
    "prod-uk" = "10.4.0.0/16"
  }
}

variable "prod_account_id" {
  description = "Prod AWS account ID"
  type        = string
}
