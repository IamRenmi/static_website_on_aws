resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids  # Correctly referencing subnet IDs

  tags = {
    Name = "RDS Subnet Group"
  }
}