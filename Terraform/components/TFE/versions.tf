terraform {
  required_version = "~> 1.1"
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.31"
    }
  }
}
