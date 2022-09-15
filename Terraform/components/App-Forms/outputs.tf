output "app-ext-alb_dns_name" {
  value       = module.App-Forms.app-ext-alb_dns_name
  description = "Domain to access the App Core external load balancer"
}

output "app-ext-alb_url" {
  value       = module.App-Forms.app-ext-alb_url
  description = "URL to access the App Core external load balancer"
}

output "app-ext-alb_r53_dns_name" {
  value       = module.App-Forms.app-ext-alb_r53_dns_name
  description = "R53 FQDN to access the App Core external load balancer"
}

output "app-ext-alb_r53_url" {
  value       = module.App-Forms.app-ext-alb_r53_url
  description = "R53 FQDN to access the App Core external load balancer"
}

output "app-int-alb_dns_name" {
  value       = module.App-Forms.app-int-alb_dns_name
  description = "domain to access the App Core internal load balancer"
}

output "app-int-alb_url" {
  value       = module.App-Forms.app-int-alb_url
  description = "URL to access the App Core internal load balancer"
}

output "app-int-alb_r53_dns_name" {
  value       = module.App-Forms.app-int-alb_r53_dns_name
  description = "R53 FQDN to access the App Core internal load balancer"
}

output "app-int-alb_r53_url" {
  value       = module.App-Forms.app-int-alb_r53_url
  description = "R53 FQDN to access the App Core internal load balancer"
}

output "cloudfront_url" {
  value       = module.App-Forms.cloudfront_url
  description = "App-Core CloudFront URL"
}

output "app_url" {
  value       = module.App-Forms.app_url
  description = "App-Core URL"
}
