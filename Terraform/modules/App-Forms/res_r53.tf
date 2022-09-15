resource "aws_route53_record" "app-ext-alb" {
  zone_id = var.r53_zone_id
  name    = "app-alb-ext"
  type    = "A"

  alias {
    name                   = aws_lb.app-ext-alb.dns_name
    zone_id                = aws_lb.app-ext-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app-int-alb" {
  zone_id = var.r53_zone_id
  name    = "app-alb-int"
  type    = "A"

  alias {
    name                   = aws_lb.app-int-alb.dns_name
    zone_id                = aws_lb.app-int-alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "forms" {
  zone_id = var.r53_zone_id
  name    = "forms"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.forms.domain_name
    zone_id                = aws_cloudfront_distribution.forms.hosted_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_health_check" "forms" {
  fqdn              = aws_route53_record.forms.fqdn
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "${var.solution_short}-${var.env}-health-check"
  }
}
