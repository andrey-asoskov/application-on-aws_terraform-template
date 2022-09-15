module "Splunk" {
  source = "../../modules/Splunk"

  asg_splunk_instance_type = var.asg_splunk_instance_type
  asg_splunk_DesiredSize   = var.asg_splunk_DesiredSize
  asg_splunk_ImageID       = lookup(var.asg_splunk_ImageID, var.env)
  asg_splunk_MaxSize       = var.asg_splunk_MaxSize
  asg_splunk_MinSize       = var.asg_splunk_MinSize
  asg_splunk_shutoff       = lookup(var.asg_splunk_shutoff, var.env)
  env                      = var.env
  env_type                 = var.env_type
  solution                 = var.solution
  solution_short           = var.solution_short
  product_id               = var.product_id
  r53_zone_id              = data.terraform_remote_state.VPC.outputs.r53_zone_id
  kms_alias_arn            = data.terraform_remote_state.VPC.outputs.kms_alias_arn
  sg_Splunk_Instance_id    = data.terraform_remote_state.VPC.outputs.sg_Splunk_Instance_id
  subnets_ids              = data.terraform_remote_state.VPC.outputs.subnets_private_ids
  vpc_id                   = data.terraform_remote_state.VPC.outputs.vpc_id
  nessus_key_ciphertext    = lookup(var.nessus_key_ciphertext, var.env)
  newrelic_key_ciphertext  = lookup(var.newrelic_key_ciphertext, var.env)
  index_name               = lookup(var.splunk_index_name, var.env)
  #splunk_admin_password_ciphertext = var.splunk_admin_password_ciphertext
  Policy_UseKMS_arn = data.terraform_remote_state.VPC.outputs.Policy_UseKMS_arn
}
