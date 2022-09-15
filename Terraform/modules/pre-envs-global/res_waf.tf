resource "aws_wafv2_ip_set" "Synack-and-DataArt-IP-ranges" {
  count              = (var.aws_account_type == "npn" ? 1 : 0)
  name               = "Synack-and-DataArt-IP-ranges"
  description        = "Synack-and-DataArt-IP-ranges-IPs_26-05-2022"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.Synack-and-DataArt-IP-ranges

  tags = {
    Name = "Synack-and-DataArt-IP-ranges"
  }
}

resource "aws_wafv2_ip_set" "company-External-IPs" {
  name               = "company-External-IPs"
  description        = "company-External-IPs-UTC"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["127.0.0.1/32"]

  tags = {
    Name = "company-External-IPs"
  }

  lifecycle {
    ignore_changes = [
      addresses,
      description
    ]
  }
}

resource "aws_lambda_invocation" "company-ips-change" {
  function_name = aws_lambda_function.company-ips-change.function_name
  input         = file("${path.module}/Lambdas/company-ips-change/payload.json")
  depends_on    = [aws_wafv2_ip_set.company-External-IPs]
}

resource "aws_wafv2_ip_set" "AWS-R53-HealthCheck-IP-ranges" {
  name               = "AWS-R53-HealthCheck-IP-ranges"
  description        = "AWS-R53-HealthCheck-IP-ranges-UTC"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["127.0.0.1/32"]

  tags = {
    Name = "AWS-R53-HealthCheck-IP-ranges"
  }

  lifecycle {
    ignore_changes = [
      addresses,
      description
    ]
  }
}

resource "aws_lambda_invocation" "AWS-R53-HealthCheck-IP-ranges" {
  function_name = aws_lambda_function.aws-ips-update_CLOUDFRONT.function_name
  input         = file("${path.module}/Lambdas/aws-ips-update_CLOUDFRONT/payload.json")
  depends_on    = [aws_wafv2_ip_set.AWS-R53-HealthCheck-IP-ranges]
}

resource "aws_wafv2_ip_set" "NR-Synthetic-monitoring-IP-ranges" {
  name               = "NR-Synthetic-monitoring-IP-ranges"
  description        = "NR-Synthetic-monitoring-IP-ranges"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["127.0.0.1/32"]

  tags = {
    Name = "NR-Synthetic-monitoring-IP-ranges"
  }
}

resource "aws_lambda_invocation" "NR-Synthetic-monitoring-IP-ranges" {
  function_name = aws_lambda_function.newrelic-ips-update.function_name
  input         = file("${path.module}/Lambdas/newrelic-ips-update/payload.json")
  depends_on    = [aws_wafv2_ip_set.NR-Synthetic-monitoring-IP-ranges]
}

resource "aws_wafv2_web_acl" "cloudfront" {
  #checkov:skip=CKV2_AWS_31:Ensure WAF2 has a Logging Configuration
  name        = "${var.solution_short}-cloudfront"
  description = "Cloudfront ACL rule for ${var.solution}"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name     = "allow-ip-addresses"
    priority = 0

    action {
      allow {}
    }

    statement {
      or_statement {
        dynamic "statement" {
          for_each = local.ip-sets
          content {
            ip_set_reference_statement {
              arn = statement.value
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-ip-addresses"
      sampled_requests_enabled   = true
    }
  }


  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesAnonymousIpList"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesAnonymousIpList"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "Fortinet-all_rules"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "all_rules"
        vendor_name = "Fortinet"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "Fortinet-all_rules"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesBotControlRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesBotControlRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "cloudfront_rules"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.solution_short}-cloudfront"
  }
}
