data "aws_ami" "trainer" {
  most_recent = true

  filter {
    name   = "tag:Name"
    values = [lookup(var.asg_app_trainer_ImageName, var.env)]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = [lookup(var.asg_app_trainer_Image_Owner, var.env)]
}

module "App-Trainer" {
  source = "../../modules/App-Trainer"

  asg_app_trainer_instance_types              = var.asg_app_trainer_instance_types
  asg_app_trainer_DesiredSize                 = lookup(var.asg_app_trainer_DesiredSize, var.env)
  asg_app_trainer_ImageName                   = data.aws_ami.trainer.image_id
  asg_app_trainer_MaxSize                     = lookup(var.asg_app_trainer_MaxSize, var.env)
  asg_app_trainer_MinSize                     = lookup(var.asg_app_trainer_MinSize, var.env)
  asg_app_trainer_shutoff                     = lookup(var.asg_app_trainer_shutoff, var.env)
  asg_app_trainer_backup                      = lookup(var.asg_app_trainer_backup, var.env)
  aws_account_type                            = var.aws_account_type
  product_id                                  = var.product_id
  env                                         = var.env
  solution                                    = var.solution
  solution_short                              = var.solution_short
  app-int-alb_r53_url                         = data.terraform_remote_state.App-Forms.outputs.app-int-alb_r53_url
  app_forms_token_ciphertext                  = lookup(var.app_forms_token_ciphertext, var.env)
  kms_alias_arn                               = data.terraform_remote_state.VPC.outputs.kms_alias_arn
  Policy_AppCoreGetFilesFromStorageBucket_arn = data.terraform_remote_state.Data.outputs.Policy_AppCoreGetFilesFromStorageBucket_arn
  Policy_UseKMS_arn                           = data.terraform_remote_state.VPC.outputs.Policy_UseKMS_arn
  sg_App_Trainer_id                           = data.terraform_remote_state.VPC.outputs.sg_App_Trainer_id
  subnets_ids                                 = data.terraform_remote_state.VPC.outputs.subnets_private_ids
  nessus_key_ciphertext                       = lookup(var.nessus_key_ciphertext, var.env)
  newrelic_key_ciphertext                     = lookup(var.newrelic_key_ciphertext, var.env)
  splunk_lb                                   = "localhost"
  splunk_lb_port                              = 8888
  #splunk_lb                                   = data.terraform_remote_state.Splunk.outputs.splunk-int-lb_r53_dns_name
  #splunk_lb_port                              = data.terraform_remote_state.Splunk.outputs.splunk-int-lb_port
}
