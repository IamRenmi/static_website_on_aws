output "arn" {
  description = "ARN of the target group wp-tg"
  value       = aws_lb_target_group.wp_tg.arn
}