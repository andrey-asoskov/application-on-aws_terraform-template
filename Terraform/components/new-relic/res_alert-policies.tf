resource "newrelic_alert_channel" "alert_notification_email_test" {
  name = "${var.solution_short}-aasoskov"
  type = "email"

  config {
    recipients              = "Andrey_asoskov@external.company.com"
    include_json_attachment = "1"
  }
}

resource "newrelic_alert_channel" "alert_notification_email_support" {
  name = "${var.solution_short}-support"
  type = "email"

  config {
    recipients              = "support@company.com"
    include_json_attachment = "1"
  }
}

resource "newrelic_alert_policy" "policy" {
  name                = "${var.solution_short}-${var.aws_account_type}-policy"
  incident_preference = "PER_CONDITION" # PER_POLICY is default
  channel_ids         = (var.aws_account_type == "npn" ? [newrelic_alert_channel.alert_notification_email_test.id] : [newrelic_alert_channel.alert_notification_email_test.id, newrelic_alert_channel.alert_notification_email_support.id])
}
