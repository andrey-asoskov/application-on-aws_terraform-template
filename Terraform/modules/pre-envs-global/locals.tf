locals {
  ip-sets = (var.aws_account_type == "npn" ? [
    aws_wafv2_ip_set.Synack-and-DataArt-IP-ranges[0].arn,
    aws_wafv2_ip_set.company-External-IPs.arn,
    aws_wafv2_ip_set.AWS-R53-HealthCheck-IP-ranges.arn,
    aws_wafv2_ip_set.NR-Synthetic-monitoring-IP-ranges.arn
    ]
    :
    [
      aws_wafv2_ip_set.company-External-IPs.arn,
      aws_wafv2_ip_set.AWS-R53-HealthCheck-IP-ranges.arn,
      aws_wafv2_ip_set.NR-Synthetic-monitoring-IP-ranges.arn
    ]
  )
}
