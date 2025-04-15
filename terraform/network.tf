data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

# Fetch subnets within the VPC
data "aws_subnets" "private" {
  # filter {
  #   name   = "vpc-id"
  #   values = [data.aws_vpc.lab_vpc.id]
  # }
  filter {
    name   = "tag:Name"
    values = ["*Private*"]  # This matches "Private Subnet 1", "Private Subnet 2", etc.
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group1"
  subnet_ids = data.aws_subnets.private.ids  # Correctly referencing subnet IDs

  tags = {
    Name = "RDS Subnet Group"
  }
}