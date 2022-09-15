data "terraform_remote_state" "pre-envs" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "pre-envs-npn"
    }
  }
}

data "terraform_remote_state" "VPC" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "VPC-dev"
    }
  }
}
