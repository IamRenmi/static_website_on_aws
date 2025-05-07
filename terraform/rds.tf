# DB Subnet Group using private_a (assuming private_a subnet was defined as aws_subnet.private_a)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_a.id]  # Add more private subnets here for HA if needed

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "wp_db" {
  identifier           = "wp-db"
  engine               = "mysql"
  engine_version       = "8.0.41"
  instance_class       = "db.t3.micro"          # Free Tier eligible class
  allocated_storage    = 20                     # Minimum required for Free Tier
  storage_type         = "gp2"
  
  username             = "admin"
  password             = "lab-password"         # Use secrets manager in production
  
  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  publicly_accessible      = false              # Disable public access

  backup_retention_period  = 7
  backup_window            = "03:00-04:00"
  maintenance_window       = "Mon:04:00-Mon:05:00"
  
  monitoring_interval      = 0
  skip_final_snapshot      = true
  deletion_protection      = false
  multi_az                 = false

  tags = {
    Name        = "wp-db"
    Environment = "Dev/Test"
  }
}

# Output the RDS endpoint
output "rds_endpoint" {
  value = aws_db_instance.wp_db.endpoint
}
