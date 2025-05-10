output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.wp_asg.name
}

output "notification_id" {
  description = "ID of the ASG notification configuration"
  value       = aws_autoscaling_notification.wp_notifications.id
}