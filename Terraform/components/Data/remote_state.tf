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
