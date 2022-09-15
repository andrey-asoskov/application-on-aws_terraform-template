output "app-ext-alb_dns_name" {
  value       = aws_lb.app-ext-alb.dns_name
  description = "Domain to access the App Core external load balancer"
}

output "app-ext-alb_url" {
  value       = "https://${aws_lb.app-ext-alb.dns_name}"
  description = "URL to access the App Core external load balancer"
}

output "app-ext-alb_r53_dns_name" {
  value       = aws_route53_record.app-ext-alb.fqdn
  description = "R53 FQDN to access the App Core external load balancer"
}

output "app-ext-alb_r53_url" {
  value       = "https://${aws_route53_record.app-ext-alb.fqdn}"
  description = "R53 FQDN to access the App Core external load balancer"
}

output "app-int-alb_dns_name" {
  value       = aws_lb.app-int-alb.dns_name
  description = "domain to access the App Core internal load balancer"
}

output "app-int-alb_url" {
  value       = "https://${aws_lb.app-int-alb.dns_name}"
  description = "URL to access the App Core internal load balancer"
}

output "app-int-alb_r53_dns_name" {
  value       = aws_route53_record.app-int-alb.fqdn
  description = "R53 FQDN to access the App Core internal load balancer"
}

output "app-int-alb_r53_url" {
  value       = "https://${aws_route53_record.app-int-alb.fqdn}"
  description = "R53 FQDN to access the App Core internal load balancer"
}

output "cloudfront_url" {
  value       = "https://${aws_cloudfront_distribution.forms.domain_name}"
  description = "App-Core CloudFront URL"
}

output "app_url" {
  value       = "https://${aws_route53_record.forms.fqdn}"
  description = "App-Core URL"
}
