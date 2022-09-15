terraform {
  backend "remote" {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces {
      name = "ec2-image-builder-dev"
    }
  }
}
