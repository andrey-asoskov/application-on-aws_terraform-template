variable "organization_name" {
  description = "Name of the TFE organization"
  type        = string
}

variable "tf_version" {
  description = "TF version used in envs"
  type        = map(string)
  default = {
    "npn"  = "1.1.3"
    "prod" = "1.1.3"
  }
}
