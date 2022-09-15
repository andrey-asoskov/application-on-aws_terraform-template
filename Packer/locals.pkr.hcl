locals {
  #timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  #timestamp = timestamp() #RFC 3339  2018-05-13T07:44:12Z
  timestamp    = formatdate("YYYY-MM-DD'T'hh-mm-ss-ZZZ", timestamp())
  app_version2 = replace(var.app_version, ".", "_")

  common_tags = {
    Solution     = var.solution
    Component    = var.component
    Environment  = var.env
    app_version  = var.app_version
    ManagedByTFE = 1
    used_for     = var.env_type == "prod" ? "prod" : "non_prod"
    product_id   = var.product_id
  }
}
