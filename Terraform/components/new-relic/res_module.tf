module "new-relic-synthetic-dev" {
  source = "../../modules/new-relic-synthetic"
  count  = (var.aws_account_type == "npn" ? 1 : 0)

  solution                 = var.solution
  solution_short           = var.solution_short
  env                      = "dev"
  uri                      = "https://forms.dev.app.company-solutions.com:443/"
  locations                = ["AWS_US_EAST_1", "AWS_US_EAST_2"]
  newrelic_alert_policy_id = newrelic_alert_policy.policy.id
}

module "new-relic-synthetic-staging" {
  source = "../../modules/new-relic-synthetic"
  count  = (var.aws_account_type == "npn" ? 1 : 0)

  solution                 = var.solution
  solution_short           = var.solution_short
  env                      = "staging"
  uri                      = "https://forms.staging.app.company-solutions.com:443/"
  locations                = ["AWS_US_EAST_1", "AWS_US_EAST_2"]
  newrelic_alert_policy_id = newrelic_alert_policy.policy.id
}

module "new-relic-synthetic-prod" {
  source = "../../modules/new-relic-synthetic"
  count  = (var.aws_account_type == "prod" ? 1 : 0)

  solution                 = var.solution
  solution_short           = var.solution_short
  env                      = "prod"
  uri                      = "https://forms.prod.app.company-solutions.com:443/"
  locations                = ["AWS_US_EAST_1", "AWS_US_EAST_2"]
  newrelic_alert_policy_id = newrelic_alert_policy.policy.id
}

module "new-relic-synthetic-prod-uk" {
  source = "../../modules/new-relic-synthetic"
  count  = (var.aws_account_type == "prod" ? 1 : 0)

  solution                 = var.solution
  solution_short           = var.solution_short
  env                      = "prod-uk"
  uri                      = "https://forms.prod-uk.app.company-solutions.com:443/"
  locations                = ["AWS_EU_WEST_1", "AWS_EU_WEST_2"]
  newrelic_alert_policy_id = newrelic_alert_policy.policy.id
}
