variable "aws_account_type" {
  description = "Type of AWS account"
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

variable "solution" {
  description = "Name of a solution"
  type        = string
}

variable "solution_short" {
  description = "Short name of a solution"
  type        = string
}

variable "asg_app_trainer_instance_types" {
  description = "Desired instance types for ASG"
  type        = list(string)
}

variable "asg_app_trainer_DesiredSize" {
  description = "Desired size for ASG"
  type        = number
}

variable "asg_app_trainer_ImageName" {
  description = "Image Name for the Trainer AMI"
  type        = string
}

variable "asg_app_trainer_MaxSize" {
  description = "Max size for ASG"
  type        = number
}

variable "asg_app_trainer_MinSize" {
  description = "Min size for ASG"
  type        = number
}

variable "asg_app_trainer_shutoff" {
  description = "IF there is a need to shut EC2 off via automation"
  type        = string
}

variable "asg_app_trainer_backup" {
  description = "IF there is a need to backup EC2 via automation"
  type        = string
}

variable "app-int-alb_r53_url" {
  type        = string
  description = "App Internal ALB R53 URL"
}

variable "app_forms_token_ciphertext" {
  type        = string
  description = "App Forms Token (encrypted)"
}

variable "kms_alias_arn" {
  type        = string
  description = "KMS Alias arn"
}

variable "Policy_AppCoreGetFilesFromStorageBucket_arn" {
  type        = string
  description = "Policy AppCoreGetFilesFromStorageBucket arn"
}

variable "Policy_UseKMS_arn" {
  type        = string
  description = "Policy UseKMS arn"
}

variable "sg_App_Trainer_id" {
  type        = string
  description = "Security Group App_Trainer id"
}

variable "subnets_ids" {
  type        = list(string)
  description = "subnets ids"
}

variable "nessus_key_ciphertext" {
  description = "Nessus key (encrypted)"
  type        = string
}

variable "newrelic_key_ciphertext" {
  description = "New Relic (encrypted)"
  type        = string
}

variable "splunk_lb" {
  description = "Splunk load balancer host name"
  type        = string
}

variable "splunk_lb_port" {
  description = "Splunk load balancer port"
  type        = number
}
