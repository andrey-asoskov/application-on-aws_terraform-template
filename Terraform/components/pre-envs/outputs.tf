// Global outputs

output "global_s3_code_bucket_id" {
  value       = module.pre-envs-global.s3_code_bucket_id
  description = "S3 Code bucket id"
}

output "global_wafv2_web_acl_cloudfront_arn" {
  value       = module.pre-envs-global.wafv2_web_acl_cloudfront_arn
  description = "WAFv2 Web ACL Cloudfront arn"
}

output "global_Policy_AppGetFilesFromCodeBucket_arn" {
  value       = module.pre-envs-global.Policy_AppGetFilesFromCodeBucket_arn
  description = "IAM Policy AppGetFilesFromCodeBucket arn"
}

output "global_Policy_UseGlobalKMS_arn" {
  value       = module.pre-envs-global.Policy_UseGlobalKMS_arn
  description = "IAM Policy Use Global KMS arn"
}

output "global_tf_apply_role_arn" {
  value       = module.pre-envs-global.tf_apply_role_arn
  description = "The ARN of IAM role TF uses for Apply"
}

output "global_tf_apply_role_name" {
  value       = module.pre-envs-global.tf_apply_role_name
  description = "The name of IAM role TF uses for Apply"
}

output "global_tf_plan_role_arn" {
  value       = module.pre-envs-global.tf_plan_role_arn
  description = "The ARN of IAM role TF uses for Plan"
}

output "global_tf_plan_role_name" {
  value       = module.pre-envs-global.tf_plan_role_name
  description = "The name of IAM role TF uses for Plan"
}

output "global_packer_build_role_arn" {
  value       = module.pre-envs-global.packer_build_role_arn
  description = "The ARN of IAM role Packer uses for build"
}

output "global_packer_build_role_name" {
  value       = module.pre-envs-global.packer_build_role_name
  description = "The name of IAM role Packer uses for build"
}


// Region outputs

output "us-east-1_wafv2_web_acl_alb_us-east-1_arn" {
  value       = module.pre-envs-us-east-1.wafv2_web_acl_alb_arn
  description = "WAFv2 Web ACL ALB us-east-1 arn"
}

output "eu-west-2_wafv2_web_acl_alb_eu-west-2_arn" {
  value       = module.pre-envs-eu-west-2.wafv2_web_acl_alb_arn
  description = "WAFv2 Web ACL ALB eu-west-2 arn"
}
