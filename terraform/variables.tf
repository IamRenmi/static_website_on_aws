variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "48.0.0.0/16"
}
variable "public_subnets" {
  description = "Map of public subnet names to CIDR blocks"
  type        = map(string)
  default = {
    "public-a" = "48.0.1.0/24"
    "public-b" = "48.0.2.0/24"
  }
}
variable "app_subnets" {
  description = "Map of app subnet names to CIDR blocks"
  type        = map(string)
  default = {
    "app-a" = "48.0.3.0/24"
    "app-b" = "48.0.4.0/24"
  }
}
variable "data_subnets" {
  description = "Map of data subnet names to CIDR blocks"
  type        = map(string)
  default = {
    "data-a" = "48.0.5.0/24"
    "data-b" = "48.0.6.0/24"
  }
}
variable "subnet_azs" {
  description = "Map of subnet names to availability zones"
  type        = map(string)
  default = {
    "public-a" = "eu-west-3-a"
    "public-b" = "eu-west-3-b"
    "app-a"    = "eu-west-3-a"
    "app-b"    = "eu-west-3-b"
    "data-a"   = "eu-west-3-a"
    "data-b"   = "eu-west-3-b"
  }
}