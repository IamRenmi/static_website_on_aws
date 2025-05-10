variable "launch_template_id" {
  description = "ID of the launch template to use"
  type        = string
}

variable "launch_template_version" {
  description = "Version of the launch template to use (e.g., '$Latest')"
  type        = string
  default     = "$Latest"
}

variable "subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "notification_topic_arn" {
  description = "ARN of the SNS topic for ASG notifications"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}