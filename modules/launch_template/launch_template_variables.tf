variable "ami_id" {
  description = "AMI ID for the EC2 launch template"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID for webserver instances (web-sg)"
  type        = string
}

variable "efs_mount_dns" {
  description = "EFS FileSystem ID (fs-xxxx)"
  type        = string
}

variable "region" {
  description = "AWS region for EFS DNS suffix"
  type        = string
}