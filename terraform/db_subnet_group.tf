resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_vpc.lab_vpc.private_subnets  # This assumes the VPC data source exposes private_subnets
                                                     # You may need to use a separate data source to fetch subnets

  tags = {
    Name = "RDS Subnet Group"
  }
}