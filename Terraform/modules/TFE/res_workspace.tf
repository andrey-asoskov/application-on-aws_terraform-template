data "tfe_organization" "org" {
  name = var.organization_name
}

resource "tfe_workspace" "workspace" {
  name              = var.workspace_name
  organization      = data.tfe_organization.org.name
  execution_mode    = "remote"
  terraform_version = var.tf_version
  working_directory = "Terraform/components/${var.component}/"
  tag_names = [
    lower(replace(var.component, "-", "")),
    lower(replace((var.env != "" ? var.env : var.aws_account_type), "-", ""))
  ]
}

resource "tfe_variable" "env" {
  count        = (var.env != "" ? 1 : 0)
  key          = "env"
  value        = var.env
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  description  = "Name of the environment"
}

resource "tfe_variable" "aws_account_type" {
  key          = "aws_account_type"
  value        = var.aws_account_type
  category     = "terraform"
  workspace_id = tfe_workspace.workspace.id
  description  = "Type of AWS account"
}
