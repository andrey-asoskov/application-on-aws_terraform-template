module "new-relic-npn" {
  source = "../../modules/TFE"

  component         = "new-relic"
  workspace_name    = "new-relic-npn"
  organization_name = var.organization_name
  env               = ""
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "new-relic-prod" {
  source = "../../modules/TFE"

  component         = "new-relic"
  workspace_name    = "new-relic-prod"
  organization_name = var.organization_name
  env               = ""
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
