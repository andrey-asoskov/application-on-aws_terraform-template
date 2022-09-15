resource "newrelic_synthetics_monitor" "url-check" {
  name = "${var.solution_short}-${var.env}-url-check"

  type      = "SIMPLE"
  frequency = 5
  status    = "ENABLED"
  locations = var.locations
  uri       = var.uri
  #validation_string         = "add example validation check here" # Optional for type "SIMPLE" and "BROWSER"
  verify_ssl = true # Optional for type "SIMPLE" and "BROWSER"
}

resource "newrelic_nrql_alert_condition" "url-check" {
  type                         = "static"
  name                         = "${var.solution_short}-${var.env}-url-check"
  policy_id                    = var.newrelic_alert_policy_id
  description                  = "${var.solution}-${var.env} Alert when url-check is taking too long"
  enabled                      = true
  violation_time_limit_seconds = 3600
  runbook_url                  = "https://confluence.mso.company.com/pages/viewpage.action?spaceKey=TO&title=SRE+Runbook+-+app+-+app"

  nrql {
    query = "SELECT average(duration) FROM SyntheticCheck where monitorId = '${newrelic_synthetics_monitor.url-check.id}'"
  }

  critical {
    operator              = "above"
    threshold             = 1500
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 1000
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
}

resource "newrelic_synthetics_monitor" "login-check" {
  name      = "${var.solution_short}-${var.env}-login-check"
  type      = "SCRIPT_BROWSER"
  frequency = 5
  status    = "ENABLED"
  locations = var.locations
}

resource "newrelic_synthetics_monitor_script" "login-check" {
  monitor_id = newrelic_synthetics_monitor.login-check.id
  text = templatefile("${path.module}/new-relic-checks/login-check.js.tftpl", {
    env  = var.env
    env2 = upper(var.env)
    }
  )
}
