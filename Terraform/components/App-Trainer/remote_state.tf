/* data "terraform_remote_state" "pre-envs" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "pre-envs-${lookup(var.env_type, var.env)}"
    }
  }
} */

data "terraform_remote_state" "VPC" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "VPC-${var.env}"
    }
  }
}

data "terraform_remote_state" "Data" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "Data-${var.env}"
    }
  }
}

data "terraform_remote_state" "App-Forms" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "App-Forms-${var.env}"
    }
  }
}

/* data "terraform_remote_state" "Splunk" {
  backend = "remote"

  config = {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces = {
      name = "Splunk-${var.env}"
    }
  }
} */
