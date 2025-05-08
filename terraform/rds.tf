# DB Subnet Group with subnets in 2 AZs (required even for single-AZ DBs)
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "wp_db" {
  identifier           = "wp-db"
  engine               = "mysql"
  engine_version       = "8.0.41"
  instance_class       = "db.t3.micro"          # Free Tier eligible
  allocated_storage    = 20
  storage_type         = "gp2"
  
  username             = "admin"
  password             = "lab-password"

  db_subnet_group_name     = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids   = [aws_security_group.rds_sg.id]
  publicly_accessible      = false

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

output "rds_endpoint" {
  description = "Endpoint of the RDS database instance"
  value       = aws_db_instance.wp_db.endpoint
}


resource "null_resource" "run_sql" {
  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.wp_db.endpoint} -u admin -p${var.WORDPRESS_DB_PASSWORD} < ../user_data/init_wp_db.sql"
  }

  depends_on = [aws_db_instance.wp_db]
}