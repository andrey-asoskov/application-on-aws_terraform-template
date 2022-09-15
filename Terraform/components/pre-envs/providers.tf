provider "aws" {
  alias      = "useast1"
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      Solution     = var.solution
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}

provider "aws" {
  alias      = "euwest2"
  region     = "eu-west-2"
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Solution     = var.solution
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}

provider "aws" {
  alias      = "eucentral1"
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Solution     = var.solution
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}
