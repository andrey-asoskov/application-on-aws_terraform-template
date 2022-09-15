terraform {
  backend "remote" {
    hostname     = "terraform.company.cloud"
    organization = "CT-SOL-APP"
    workspaces {
      prefix = "Splunk-"
    }
  }
}
