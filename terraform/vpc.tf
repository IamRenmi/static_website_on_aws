resource "aws_vpc" "web-vpc" {
  cidr_block = "48.0.0.0/24"
  tags = {
    name = 'web-vpc'
  }
}

resource "aws_subnet" "" {
  vpc_id     = aws_vpc.web-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}