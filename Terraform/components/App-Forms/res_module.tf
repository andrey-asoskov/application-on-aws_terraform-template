data "aws_region" "current" {}

data "aws_ami" "forms" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = [lookup(var.asg_app_forms_ImageName, var.env)]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = [lookup(var.asg_app_forms_Image_Owner, var.env)]
}

module "App-Forms" {
  source = "../../modules/App-Forms"

  asg_app_forms_instance_types = var.asg_app_forms_instance_types
  asg_app_forms_DesiredSize    = lookup(var.asg_app_forms_DesiredSize, var.env)
  asg_app_forms_ImageName      = data.aws_ami.forms.image_id
  asg_app_forms_MaxSize        = lookup(var.asg_app_forms_MaxSize, var.env)
  asg_app_forms_MinSize        = lookup(var.asg_app_forms_MinSize, var.env)
  asg_app_forms_shutoff        = lookup(var.asg_app_forms_shutoff, var.env)
  asg_app_forms_backup         = lookup(var.asg_app_forms_backup, var.env)
  db_name                      = var.db_name
  db_username                  = var.db_username
  aws_account_type             = var.aws_account_type
  product_id                   = var.product_id
  env                          = var.env
  env_type                     = lookup(var.env_type, var.env)
  solution                     = var.solution
  solution_short               = var.solution_short
  r53_zone_id                  = data.terraform_remote_state.VPC.outputs.r53_zone_id
  kms_alias_arn                = data.terraform_remote_state.VPC.outputs.kms_alias_arn
  #Policy_AppGetFilesFromCodeBucket_arn        = data.terraform_remote_state.pre-envs.outputs.Policy_AppGetFilesFromCodeBucket_arn
  Policy_GetFilesFromStorageBucket_arn = data.terraform_remote_state.Data.outputs.Policy_AppCoreGetFilesFromStorageBucket_arn
  Policy_UseKMS_arn                    = data.terraform_remote_state.VPC.outputs.Policy_UseKMS_arn
  wafv2_web_acl_cloudfront_arn         = data.terraform_remote_state.pre-envs.outputs.global_wafv2_web_acl_cloudfront_arn
  wafv2_web_acl_alb_arn                = lookup(local.wafv2_web_acl_alb, data.aws_region.current.name)
  s3_storage_bucket_id                 = data.terraform_remote_state.Data.outputs.s3_storage_bucket_id
  db_address_r53_dns_name              = data.terraform_remote_state.Data.outputs.db_address_r53_dns_name
  sg_App_Forms_id                      = data.terraform_remote_state.VPC.outputs.sg_App_Forms_id
  sg_App_Forms_ALB_id                  = data.terraform_remote_state.VPC.outputs.sg_App_Forms_ALB_id
  subnets_public_ids                   = data.terraform_remote_state.VPC.outputs.subnets_public_ids
  subnets_private_ids                  = data.terraform_remote_state.VPC.outputs.subnets_private_ids
  s3_access-logs_bucket_id             = data.terraform_remote_state.VPC.outputs.s3_access-logs_bucket_id
  vpc_id                               = data.terraform_remote_state.VPC.outputs.vpc_id
  nessus_key_ciphertext                = lookup(var.nessus_key_ciphertext, var.env)
  newrelic_key_ciphertext              = lookup(var.newrelic_key_ciphertext, var.env)
  #splunk_lb                            = data.terraform_remote_state.Splunk.outputs.splunk-int-lb_r53_dns_name
  #splunk_lb_port                       = data.terraform_remote_state.Splunk.outputs.splunk-int-lb_port
  splunk_lb                              = "localhost"
  splunk_lb_port                         = 8888
  HS_OIDC_RP_CLIENT_ID                   = lookup(var.HS_OIDC_RP_CLIENT_ID, var.env)
  HS_OIDC_LOGGER_LEVEL                   = lookup(var.HS_OIDC_LOGGER_LEVEL, var.env)
  HS_OIDC_ADMIN_GROUP                    = lookup(var.HS_OIDC_ADMIN_GROUP, var.env)
  secretmanager_name                     = data.terraform_remote_state.Data.outputs.secretmanager_name
  Policy_GetValuesFromSecretsManager_arn = data.terraform_remote_state.Data.outputs.Policy_GetValuesFromSecretsManager_arn

  providers = {
    aws         = aws
    aws.useast1 = aws.useast1
  }
}
