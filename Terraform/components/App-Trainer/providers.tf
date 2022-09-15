provider "aws" {
  region = lookup(var.aws_region, var.env)
  default_tags {
    tags = {
      Solution     = var.solution
      component    = "trainer"
      Environment  = var.env
      ManagedByTFE = 1
      used_for     = var.aws_account_type == "prod" ? "prod" : "non_prod"
      product_id   = var.product_id
    }
  }
}
