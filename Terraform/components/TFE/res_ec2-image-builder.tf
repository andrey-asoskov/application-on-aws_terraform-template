module "ec2-image-builder-dev" {
  source = "../../modules/TFE"

  component         = "ec2-image-builder"
  workspace_name    = "ec2-image-builder-dev"
  organization_name = var.organization_name
  env               = "dev"
  aws_account_type  = "npn"
  tf_version        = lookup(var.tf_version, "npn")
}
