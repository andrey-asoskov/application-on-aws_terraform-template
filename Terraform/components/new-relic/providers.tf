provider "newrelic" {
  account_id = lookup(var.account_id, var.aws_account_type)
  api_key    = var.api_key # usually prefixed with 'NRAK'
  region     = "US"        # Valid regions are US and EU
}
