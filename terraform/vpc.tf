data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}

# Fetch subnets within the VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.lab_vpc.id]
  }
}