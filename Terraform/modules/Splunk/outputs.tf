output "splunk-int-lb_dns_name" {
  value       = aws_lb.splunk-int-lb.dns_name
  description = "domain to access the Splunk internal load balancer"
}

output "splunk-int-lb_r53_dns_name" {
  value       = aws_route53_record.splunk-lb-int.fqdn
  description = "R53 FQDN to access the Splunk internal load balancer"
}

output "splunk-int-lb_port" {
  value       = "9997"
  description = "TCP Port to access the Splunk internal load balancer"
}
