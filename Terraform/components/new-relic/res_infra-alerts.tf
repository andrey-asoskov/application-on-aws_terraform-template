resource "newrelic_infra_alert_condition" "high_disk_usage" {
  policy_id = newrelic_alert_policy.policy.id

  name        = "High disk usage"
  description = "Warning if disk usage goes above 80% and critical alert if goes above 90%"
  type        = "infra_metric"
  event       = "StorageSample"
  select      = "diskUsedPercent"
  comparison  = "above"
  runbook_url = "https://confluence.mso.company.com/pages/viewpage.action?spaceKey=TO&title=SRE+Runbook+-+app+-+app"

  critical {
    duration      = 5
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 80
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "high_memory_usage" {
  policy_id = newrelic_alert_policy.policy.id

  name        = "High memory usage"
  description = "Warning if memory usage goes above 80% and critical alert if goes above 90%"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "memoryUsedBytes/memoryTotalBytes*100"
  comparison  = "above"
  runbook_url = "https://confluence.mso.company.com/pages/viewpage.action?spaceKey=TO&title=SRE+Runbook+-+app+-+app"

  critical {
    duration      = 5
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 5
    value         = 80
    time_function = "all"
  }
}

resource "newrelic_infra_alert_condition" "high_cpu_usage" {
  policy_id = newrelic_alert_policy.policy.id

  name        = "High CPU usage"
  description = "Warning if CPU usage goes above 80% and critical alert if goes above 90%"
  type        = "infra_metric"
  event       = "SystemSample"
  select      = "cpuPercent"
  comparison  = "above"
  runbook_url = "https://confluence.mso.company.com/pages/viewpage.action?spaceKey=TO&title=SRE+Runbook+-+app+-+app"

  critical {
    duration      = 15
    value         = 90
    time_function = "all"
  }

  warning {
    duration      = 15
    value         = 80
    time_function = "all"
  }
}
