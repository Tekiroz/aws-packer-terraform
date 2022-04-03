output "instance_id" {
  value       = [for instance in aws_instance.this : instance.id ]
  description = "Instances ID."
}

output "instance_ip" {
  value       = [for instance in aws_instance.this : instance.public_ip ]
  description = "Instances IP."
}