output "splunk-int-lb_dns_name" {
  value       = module.Splunk.splunk-int-lb_dns_name
  description = "domain to access the Splunk internal load balancer"
}

output "splunk-int-lb_r53_dns_name" {
  value       = module.Splunk.splunk-int-lb_r53_dns_name
  description = "R53 FQDN to access the Splunk internal load balancer"
}

output "splunk-int-lb_port" {
  value       = module.Splunk.splunk-int-lb_port
  description = "TCP Port to access the Splunk internal load balancer"
}
