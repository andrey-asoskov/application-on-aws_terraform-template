resource "aws_acm_certificate" "cloudfront" {
  domain_name       = "*.${var.env}.app.company-solutions.com"
  validation_method = "DNS"

  tags = {
    Name = "wildcard.${var.env}.app.company-solutions.com"
  }

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.useast1
}

resource "aws_route53_record" "cloudfront" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.r53_zone_id

  provider = aws.useast1
}

resource "aws_acm_certificate_validation" "cloudfront" {
  certificate_arn         = aws_acm_certificate.cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.cloudfront : record.fqdn]

  provider = aws.useast1
}

resource "aws_acm_certificate" "alb" {
  domain_name       = "*.${var.env}.app.company-solutions.com"
  validation_method = "DNS"

  tags = {
    Name = "wildcard.${var.env}.app.company-solutions.com"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "alb" {
  for_each = {
    for dvo in aws_acm_certificate.alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.r53_zone_id
}

resource "aws_acm_certificate_validation" "alb" {
  certificate_arn         = aws_acm_certificate.alb.arn
  validation_record_fqdns = [for record in aws_route53_record.alb : record.fqdn]
}
