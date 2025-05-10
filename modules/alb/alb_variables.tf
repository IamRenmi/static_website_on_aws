variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_ids" {
  description = "Map of logical names to instance IDs to register"
  type        = map(string)
}

variable "port" {
  description = "Port for target group"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol for target group"
  type        = string
  default     = "HTTP"
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    interval            = number
    timeout             = number
    unhealthy_threshold = number
    healthy_threshold   = number
    matcher             = string
  })
  default = {
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 5
    matcher             = "200-302"
  }
}