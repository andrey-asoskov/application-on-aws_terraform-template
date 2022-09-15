module "Splunk-dev" {
  source = "../../modules/TFE"

  component         = "Splunk"
  workspace_name    = "Splunk-dev"
  organization_name = var.organization_name
  env               = "dev"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "Splunk-staging" {
  source = "../../modules/TFE"

  component         = "Splunk"
  workspace_name    = "Splunk-staging"
  organization_name = var.organization_name
  env               = "staging"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}

module "Splunk-prod" {
  source = "../../modules/TFE"

  component         = "Splunk"
  workspace_name    = "Splunk-prod"
  organization_name = var.organization_name
  env               = "prod"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}

module "Splunk-prod-uk" {
  source = "../../modules/TFE"

  component         = "Splunk"
  workspace_name    = "Splunk-prod-uk"
  organization_name = var.organization_name
  env               = "prod-uk"
  aws_account_type  = "prod"
  tf_version        = lookup(var.tf_version, "prod")
}
