provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Solution     = var.solution
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}
