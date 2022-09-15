output "s3_code_bucket_id" {
  value       = aws_s3_bucket.code_bucket.id
  description = "S3 Code bucket id"
}

output "wafv2_web_acl_cloudfront_arn" {
  value       = aws_wafv2_web_acl.cloudfront.arn
  description = "WAFv2 Web ACL Cloudfront arn"
}

output "Policy_AppGetFilesFromCodeBucket_arn" {
  value       = aws_iam_policy.AppGetFilesFromCodeBucket.arn
  description = "IAM Policy AppGetFilesFromCodeBucket arn"
}

output "Policy_UseGlobalKMS_arn" {
  value       = aws_iam_policy.global-key.arn
  description = "IAM Policy UseGlobalKMS arn"
}

output "backup_role_arn" {
  value       = aws_iam_role.backup_role.arn
  description = "IAM Role ARN for Backup"
}

output "tf_plan_role_name" {
  value       = aws_iam_role.tf_plan.name
  description = "The name of IAM role TF uses for Plan"
}

output "tf_plan_role_arn" {
  value       = aws_iam_role.tf_plan.arn
  description = "The ARN of IAM role TF uses for Plan"
}

output "tf_apply_role_name" {
  value       = aws_iam_role.tf_apply.name
  description = "The name of IAM role TF uses for Apply"
}

output "tf_apply_role_arn" {
  value       = aws_iam_role.tf_apply.arn
  description = "The ARN of IAM role TF uses for Apply"
}

output "packer_build_role_name" {
  value       = aws_iam_role.packer_build.name
  description = "The name of IAM role Packer uses for build"
}

output "packer_build_role_arn" {
  value       = aws_iam_role.packer_build.arn
  description = "The ARN of IAM role Packer uses for build"
}
