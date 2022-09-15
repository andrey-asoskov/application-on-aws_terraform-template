// VPC
output "vpc_id" {
  value       = module.VPC.vpc_id
  description = "VPC id"
}

// Subnets
output "subnets_private_ids" {
  value       = module.VPC.subnets_private_ids
  description = "Private subnets ids"
}

output "subnets_public_ids" {
  value       = module.VPC.subnets_public_ids
  description = "Public subnets ids"
}

//Security Groups
output "sg_App_Forms_id" {
  value       = module.VPC.sg_App_Forms_id
  description = "App Core security group id"
}

output "sg_App_Trainer_id" {
  value       = module.VPC.sg_App_Trainer_id
  description = "App Trainer security group id"
}

output "sg_DataDB_id" {
  value       = module.VPC.sg_DataDB_id
  description = "DB security group id"
}

output "sg_App_Forms_ALB_id" {
  value       = module.VPC.sg_App_Forms_ALB_id
  description = "ALB security group id"
}

output "sg_Splunk_Instance_id" {
  value       = module.VPC.sg_Splunk_Instance_id
  description = "Splunk Instance security group id"
}

output "r53_zone_name_servers" {
  value       = module.VPC.r53_zone_name_servers
  description = "List of name servers for DNS zone"
}

output "r53_zone_id" {
  value       = module.VPC.r53_zone_id
  description = "DNS zone id"
}

output "kms_key_id" {
  value       = module.VPC.kms_key_id
  description = "KMS key ID"
}

output "kms_key_arn" {
  value       = module.VPC.kms_key_arn
  description = "KMS key Arn"
}

output "kms_alias_id" {
  value       = module.VPC.kms_alias_id
  description = "KMS Alias ID"
}

output "kms_alias_arn" {
  value       = module.VPC.kms_alias_arn
  description = "KMS Alias Arn"
}

output "kms_alias_target_key_arn" {
  value       = module.VPC.kms_alias_target_key_arn
  description = "KMS Alias Target Key Arn"
}

output "Policy_UseKMS_arn" {
  value       = module.VPC.Policy_UseKMS_arn
  description = "KMS Policy Arn"
}

output "s3_access-logs_bucket_id" {
  value       = module.VPC.s3_access-logs_bucket_id
  description = "S3 Bucket for access logs id"
}
