module "App-Forms-dev" {
  source = "../../modules/TFE"

  component         = "App-Forms"
  workspace_name    = "App-Forms-dev"
  organization_name = var.organization_name
  env               = "dev"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "App-Forms-staging" {
  source = "../../modules/TFE"

  component         = "App-Forms"
  workspace_name    = "App-Forms-staging"
  organization_name = var.organization_name
  env               = "staging"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "App-Forms-prod" {
  source = "../../modules/TFE"

  component         = "App-Forms"
  workspace_name    = "App-Forms-prod"
  organization_name = var.organization_name
  env               = "prod"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}

module "App-Forms-prod-uk" {
  source = "../../modules/TFE"

  component         = "App-Forms"
  workspace_name    = "App-Forms-prod-uk"
  organization_name = var.organization_name
  env               = "prod-uk"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
