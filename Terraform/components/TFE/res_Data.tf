module "Data-dev" {
  source = "../../modules/TFE"

  component         = "Data"
  workspace_name    = "Data-dev"
  organization_name = var.organization_name
  env               = "dev"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "Data-staging" {
  source = "../../modules/TFE"

  component         = "Data"
  workspace_name    = "Data-staging"
  organization_name = var.organization_name
  env               = "staging"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "Data-prod" {
  source = "../../modules/TFE"

  component         = "Data"
  workspace_name    = "Data-prod"
  organization_name = var.organization_name
  env               = "prod"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}

module "Data-prod-uk" {
  source = "../../modules/TFE"

  component         = "Data"
  workspace_name    = "Data-prod-uk"
  organization_name = var.organization_name
  env               = "prod-uk"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
