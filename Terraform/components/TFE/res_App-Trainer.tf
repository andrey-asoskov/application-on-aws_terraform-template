module "App-Trainer-dev" {
  source = "../../modules/TFE"

  component         = "App-Trainer"
  workspace_name    = "App-Trainer-dev"
  organization_name = var.organization_name
  env               = "dev"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "App-Trainer-staging" {
  source = "../../modules/TFE"

  component         = "App-Trainer"
  workspace_name    = "App-Trainer-staging"
  organization_name = var.organization_name
  env               = "staging"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "App-Trainer-prod" {
  source = "../../modules/TFE"

  component         = "App-Trainer"
  workspace_name    = "App-Trainer-prod"
  organization_name = var.organization_name
  env               = "prod"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}

module "App-Trainer-prod-uk" {
  source = "../../modules/TFE"

  component         = "App-Trainer"
  workspace_name    = "App-Trainer-prod-uk"
  organization_name = var.organization_name
  env               = "prod-uk"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
