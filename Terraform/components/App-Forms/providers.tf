provider "aws" {
  region     = lookup(var.aws_region, var.env)
  access_key = var.access_key
  secret_key = var.secret_key
  default_tags {
    tags = {
      Solution     = var.solution
      component    = "forms"
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}

provider "aws" {
  alias      = "useast1"
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = {
      Solution     = var.solution
      component    = "forms"
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}
