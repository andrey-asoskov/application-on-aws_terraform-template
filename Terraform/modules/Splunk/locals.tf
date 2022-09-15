locals {
  common_tags = {
    Solution     = var.solution
    Environment  = var.env
    ManagedByTFE = 1
    used_for     = var.env_type == "prod" ? "prod" : "non_prod"
    product_id   = var.product_id
  }
}
