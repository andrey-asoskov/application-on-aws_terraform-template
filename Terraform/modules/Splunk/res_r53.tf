resource "aws_route53_record" "splunk-lb-int" {
  zone_id = var.r53_zone_id
  name    = "splunk-lb-int"
  type    = "A"

  alias {
    name                   = aws_lb.splunk-int-lb.dns_name
    zone_id                = aws_lb.splunk-int-lb.zone_id
    evaluate_target_health = true
  }
}
