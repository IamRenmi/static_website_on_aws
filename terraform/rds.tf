resource "aws_db_instance" "lab_db" {
  identifier           = "lab-db1"
  engine               = "mysql"  # Could also be "aurora" based on requirements
  engine_version       = "8.0"    # Update this to your preferred version
  instance_class       = "db.t3.small"  # You can choose between db.t*.micro to db.t*.medium
  allocated_storage    = 20      # Up to 100 GB as per requirements
  storage_type         = "gp2"   # General Purpose SSD
  
  # Database credentials
  username             = "admin"
  password             = "lab-password"  # In production, use secrets manager or similar
  
  # Network & security
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible  = false
  
  # Backups and maintenance
  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"
  
  # Additional configuration
  monitoring_interval     = 0  # Disable enhanced monitoring as per requirement
  skip_final_snapshot     = true  # For dev/test environments
  deletion_protection     = false # For dev/test environments
  
  # Disable Multi-AZ deployment (standby instance)
  multi_az               = false
  
  tags = {
    Name = "lab-db1"
    Environment = "Dev/Test"
  }
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.lab_db.endpoint
}