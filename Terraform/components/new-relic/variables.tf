variable "account_id" {
  description = "NR account ID"
  type        = map(number)
  default = {
    "npn"  = "3224997"
    "prod" = "3224996"
  }
}

variable "api_key" {
  description = "NR API key"
  type        = string
}

variable "aws_account_type" {
  description = "Type of AWS environment"
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
