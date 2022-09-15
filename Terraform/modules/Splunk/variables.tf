variable "env" {
  description = "Name of an environment"
  type        = string
}

variable "env_type" {
  description = "Type of an environment"
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

variable "asg_splunk_instance_type" {
  description = "Desired instance type for ASG"
  type        = string
}

variable "asg_splunk_DesiredSize" {
  description = "Desired size for ASG"
  type        = number
}

variable "asg_splunk_ImageID" {
  description = "Image ID for the Splunk"
  type        = string
}

variable "asg_splunk_MaxSize" {
  description = "Max size for ASG"
  type        = number
}

variable "asg_splunk_MinSize" {
  description = "Min size for ASG"
  type        = number
}

variable "asg_splunk_shutoff" {
  description = "IF there is a need to shut EC2 off via automation"
  type        = string
}

variable "r53_zone_id" {
  description = "R53 Zone id"
  type        = string
}

variable "kms_alias_arn" {
  type        = string
  description = "KMS Alias arn"
}

variable "sg_Splunk_Instance_id" {
  type        = string
  description = "SG Splunk Instance id"
}

variable "subnets_ids" {
  type        = list(string)
  description = "subnets ids"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "nessus_key_ciphertext" {
  description = "Nessus key (encrypted)"
  type        = string
}

variable "newrelic_key_ciphertext" {
  description = "New Relic (encrypted)"
  type        = string
}

/*variable "splunk_admin_password_ciphertext" {
  description = "NSplunk Admin PW (encrypted)"
  type        = string
}*/

variable "index_name" {
  description = "Splunk Index name"
  type        = string
}

variable "target_uri" {
  description = "Splunk target uri"
  type        = map(any)
  default = {
    "npn"  = "splunk-npn-aws-us-east-1.company-solutions.com:8089"
    "prod" = "splunk-aws-us-east-1.company-solutions.com:8089"
  }
}

variable "shared_splunk_srv_lb_port" {
  description = "Shared Splunk LB port"
  default     = "9997"
  type        = number
}

variable "shared_splunk_srv_deployment_port" {
  description = "Shared Splunk Deployment port"
  default     = "8089"
  type        = number
}

variable "shared_splunk_srv_dns" {
  description = "DNS name for Shared Splunk ELB endpoint"
  type        = map(any)

  default = {
    "npn"  = "splunk-npn-aws-us-east-1.company-solutions.com"
    "prod" = "splunk-aws-us-east-1.company-solutions.com"
  }
}

variable "Policy_UseKMS_arn" {
  type        = string
  description = "Policy UseKMS arn"
}
