output "app_server_alb_dns" {
  value = aws_lb.app_alb.dns_name
  description = "Domain name of the Application Servers ALB."
}