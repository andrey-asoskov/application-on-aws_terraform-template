resource "aws_wafv2_ip_set" "AWS-CloudFront-IP-ranges" {
  name               = "AWS-CloudFront-IP-ranges"
  description        = "AWS-CloudFront-IP-ranges"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["127.0.0.1/32"]

  tags = {
    Name = "AWS-CloudFront-IP-ranges"
  }

  lifecycle {
    ignore_changes = [
      addresses,
      description
    ]
  }
}

resource "aws_wafv2_web_acl" "alb" {
  #checkov:skip=CKV_AWS_192:Ensure WAF prevents message lookup in Log4j2. See CVE-2021-44228 aka log4jshell - Configured on CloudFront level
  #checkov:skip=CKV2_AWS_31:Ensure WAF2 has a Logging Configuration
  name        = "${var.solution_short}-alb"
  description = "ACL rule for ${var.solution}-alb"
  scope       = "REGIONAL"

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
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.AWS-CloudFront-IP-ranges.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "allow-ip-addresses"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesLinuxRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWS-AWSManagedRulesLinuxRuleSet"
      sampled_requests_enabled   = true
    }
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    #metric_name                = "Fortinet-all_rules"
    metric_name              = "alb_rules"
    sampled_requests_enabled = true
  }

  tags = {
    Name = "${var.solution_short}-alb"
  }
}
