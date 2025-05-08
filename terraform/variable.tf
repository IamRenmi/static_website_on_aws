variable "WORDPRESS_DIR" {
  description = "Directory where WordPress will be installed"
  type        = string
  default     = "/var/www/html"
}

# variable "EFS_DNS_ENDPOINT" {
#   description = "EFS DNS endpoint created by Terraform"
#   type        = string
# }

variable "FILE_SYSTEM_TABLE" {
  description = "Path to fstab file"
  type        = string
  default     = "/etc/fstab"
}

variable "WORDPRESS_URL" {
  description = "Download URL for WordPress"
  type        = string
  default     = "https://wordpress.org/latest.tar.gz"
}

variable "PHP_INIT" {
  description = "Path to php.ini"
  type        = string
  default     = "/etc/php.ini"
}

# variable "DB_ENDPOINT" {
#   description = "RDS database endpoint created by Terraform"
#   type        = string
# }

variable "WORDPRESS_DB" {
  description = "WordPress database name"
  type        = string
  default     = "wordpress"
}

variable "WORDPRESS_DB_USER" {
  description = "WordPress database username"
  type        = string
  default     = "wp-user"
}

variable "WORDPRESS_DB_PASSWORD" {
  description = "WordPress database password"
  type        = string
  default     = "lab-password"
  sensitive   = true
}

variable "UPLOAD_MAX_FILESIZE" {
  description = "PHP upload_max_filesize setting"
  type        = string
  default     = "64M"
}

variable "POST_MAX_SIZE" {
  description = "PHP post_max_size setting"
  type        = string
  default     = "64M"
}

variable "MEMORY_LIMIT" {
  description = "PHP memory_limit setting"
  type        = string
  default     = "128M"
}
