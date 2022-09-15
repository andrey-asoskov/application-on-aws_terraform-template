output "db_address" {
  value       = module.Data.db_address
  description = "DB DNS name"
}

output "db_address_r53_dns_name" {
  value       = module.Data.db_address_r53_dns_name
  description = "DB R53 DNS name"
}

output "s3_storage_bucket_id" {
  value       = module.Data.s3_storage_bucket_id
  description = "S3 Storage bucket id"
}

output "Policy_AppCoreGetFilesFromStorageBucket_arn" {
  value       = module.Data.Policy_AppCoreGetFilesFromStorageBucket_arn
  description = "IAM Policy AppCoreGetFilesFromStorageBucket arn"
}

output "secretmanager_name" {
  value       = module.Data.secretmanager_name
  description = "Secret Manager name"
}

output "Policy_GetValuesFromSecretsManager_arn" {
  value       = module.Data.Policy_GetValuesFromSecretsManager_arn
  description = "IAM Policy GetValuesFromSecretsManager arn"
}
