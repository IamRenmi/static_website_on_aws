variable "name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the SNS topic"
  type        = map(string)
  default     = {}
}