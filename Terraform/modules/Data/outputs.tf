output "db_address" {
  value       = aws_db_instance.db.address
  description = "DB DNS name"
}

output "db_address_r53_dns_name" {
  value       = aws_route53_record.db.fqdn
  description = "DB R53 DNS name"
}

output "s3_storage_bucket_id" {
  value       = aws_s3_bucket.storage.id
  description = "S3 Storage bucket id"
}

output "Policy_AppCoreGetFilesFromStorageBucket_arn" {
  value       = aws_iam_policy.AppCoreGetFilesFromStorageBucket.arn
  description = "IAM Policy AppCoreGetFilesFromStorageBucket arn"
}

output "secretmanager_name" {
  value       = "${var.solution_short}-${var.env}"
  description = "Secret Manager name"
}

output "Policy_GetValuesFromSecretsManager_arn" {
  value       = aws_iam_policy.GetValuesFromSecretsManager.arn
  description = "IAM Policy GetValuesFromSecretsManager arn"
}
