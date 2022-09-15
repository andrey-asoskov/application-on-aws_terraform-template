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

variable "asg_app_forms_instance_types" {
  description = "Desired instance types for ASG"
  type        = list(string)
}

variable "asg_app_forms_DesiredSize" {
  description = "Desired size for ASG"
  type        = number
}

variable "asg_app_forms_ImageName" {
  description = "Image Name for the Forms AMI"
  type        = string
}

variable "asg_app_forms_MaxSize" {
  description = "Max size for ASG"
  type        = number
}

variable "asg_app_forms_MinSize" {
  description = "Min size for ASG"
  type        = number
}

variable "asg_app_forms_shutoff" {
  description = "IF there is a need to shut EC2 off via automation"
  type        = string
}

variable "asg_app_forms_backup" {
  description = "IF there is a need to backup EC2 via automation"
  type        = string
}

variable "aws-elb-access-logs_bucket" {
  description = "IF there is a need to backup EC2 via automation"
  type        = map(string)
  default = {
    "dev"     = "aws-elb-access-logs-468409605596-us-east-1"
    "staging" = "aws-elb-access-logs-468409605596-us-east-1"
    "prod"    = "aws-elb-access-logs-468409605596-us-east-1"
    "prod-uk" = "aws-elb-access-logs-468409605596-eu-west-2"
  }
}

variable "db_name" {
  description = "DB name"
  type        = string
}

variable "db_username" {
  description = "username for db connection used by the app"
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

variable "Policy_GetFilesFromStorageBucket_arn" {
  type        = string
  description = "Policy GetFilesFromStorageBucket arn"
}

variable "Policy_UseKMS_arn" {
  type        = string
  description = "Policy UseKMS arn"
}

variable "wafv2_web_acl_cloudfront_arn" {
  type        = string
  description = "WAFv2 Web ACL Cloudfront arn"
}

variable "wafv2_web_acl_alb_arn" {
  type        = string
  description = "WAFv2 Web ACL ALB arn"
}

variable "s3_storage_bucket_id" {
  type        = string
  description = "S3 storage bucket id"
}

variable "db_address_r53_dns_name" {
  type        = string
  description = "DB address R53 DNS name"
}

variable "sg_App_Forms_id" {
  type        = string
  description = "SG App Forms id"
}

variable "sg_App_Forms_ALB_id" {
  type        = string
  description = "sg App Forms ALB id"
}

variable "subnets_public_ids" {
  type        = list(string)
  description = "subnets public ids"
}

variable "subnets_private_ids" {
  type        = list(string)
  description = "subnets private ids"
}

variable "s3_access-logs_bucket_id" {
  type        = string
  description = "s3 http access logs bucket id"
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

variable "splunk_lb" {
  description = "Splunk load balancer host name"
  type        = string
}

variable "splunk_lb_port" {
  description = "Splunk load balancer port"
  type        = number
}

variable "HS_OIDC_RP_CLIENT_ID" {
  description = "OIDC client ID"
  type        = string
}

variable "HS_OIDC_LOGGER_LEVEL" {
  description = "OIDC logger level"
  type        = string
}

variable "HS_OIDC_ADMIN_GROUP" {
  description = "OIDC admin group name"
  type        = string
}

variable "Policy_GetValuesFromSecretsManager_arn" {
  type        = string
  description = "Policy GetValuesFromSecretsManager arn"
}

variable "secretmanager_name" {
  description = "secretmanager name"
  type        = string
}
