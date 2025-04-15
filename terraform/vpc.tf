data "aws_vpc" "lab_vpc" {
  tags = {
    Name = "Lab VPC"
  }
}
