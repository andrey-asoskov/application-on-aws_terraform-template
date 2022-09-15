resource "aws_cloudfront_distribution" "forms" {
  aliases             = ["forms.${var.env}.app.company-solutions.com"]
  enabled             = true
  comment             = "${var.solution_short}-${var.env}-app-forms-cloudfront"
  default_root_object = "login"
  http_version        = "http2"
  is_ipv6_enabled     = false
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  web_acl_id          = var.wafv2_web_acl_cloudfront_arn

  origin {
    domain_name = aws_route53_record.app-ext-alb.fqdn
    origin_id   = "app-forms"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]
    cached_methods = [
      "GET",
      "HEAD",
      "OPTIONS"
    ]
    compress                   = false
    default_ttl                = 0
    max_ttl                    = 0
    min_ttl                    = 0
    smooth_streaming           = false
    target_origin_id           = "app-forms"
    trusted_signers            = []
    viewer_protocol_policy     = "https-only"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03" #checkov:skip=CKV2_AWS_32:Ensure CloudFront distribution has a strict security headers policy attached

    forwarded_values {
      query_string = true
      headers      = ["*"]

      cookies {
        forward = "all"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/static/"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "app-forms"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                    = 0
    default_ttl                = 86400
    max_ttl                    = 31536000
    compress                   = true
    viewer_protocol_policy     = "https-only"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  ordered_cache_behavior {
    path_pattern     = "*/favicon.ico"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "app-forms"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                    = 0
    default_ttl                = 86400
    max_ttl                    = 31536000
    compress                   = true
    viewer_protocol_policy     = "https-only"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  ordered_cache_behavior {
    path_pattern     = "*.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "app-forms"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    min_ttl                    = 0
    default_ttl                = 86400
    max_ttl                    = 31536000
    compress                   = true
    viewer_protocol_policy     = "https-only"
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = aws_acm_certificate.cloudfront.arn
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  logging_config {
    include_cookies = true
    bucket          = "${var.s3_access-logs_bucket_id}.s3.amazonaws.com"
    prefix          = "cloudfront"
  }

  tags = {
    Name = "${var.solution_short}-${var.env}-app-forms-cloudfront"
  }

  depends_on = [
    aws_acm_certificate_validation.cloudfront
  ]
}

