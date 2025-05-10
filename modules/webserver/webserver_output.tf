output "webserver_ids" {
  description = "IDs of webserver instances"
  value       = aws_instance.web[*].id
}

output "webserver_ips" {
  description = "Private IPs of webserver instances"
  value       = aws_instance.web[*].private_ip
}