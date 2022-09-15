module "pre-envs-npn" {
  source = "../../modules/TFE"

  component         = "pre-envs"
  workspace_name    = "pre-envs-npn"
  organization_name = var.organization_name
  env               = ""
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "pre-envs-prod" {
  source = "../../modules/TFE"

  component         = "pre-envs"
  workspace_name    = "pre-envs-prod"
  organization_name = var.organization_name
  env               = ""
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
