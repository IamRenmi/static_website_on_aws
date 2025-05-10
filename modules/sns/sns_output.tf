output "topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.this.arn
}

output "subscription_id" {
  description = "ID of the SNS subscription"
  value       = aws_sns_topic_subscription.this.id
}