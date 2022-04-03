output "instances_id" {
  value       = module.ec2-nodes.instance_id
  description = "The ID of all instances created."
}

output "instances_ip" {
  value       = module.ec2-nodes.instance_ip
  description = "The IPv4 of all instances created."
}

output "alb_dns_name" {
  value       = "http://${aws_lb.this.dns_name}"
  description = "Application Load Balancer url."
}