variable "name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "tags" {
  description = "Tags applied to the SNS topic"
  type        = map(string)
  default     = {}
}

variable "subscription_protocol" {
  description = "Protocol for the SNS subscription (e.g., email)"
  type        = string
}

variable "subscription_endpoint" {
  description = "Endpoint for the SNS subscription"
  type        = string
}