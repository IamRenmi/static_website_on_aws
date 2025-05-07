resource "aws_vpc" "wordpress_vpc" {
  cidr_block = "48.0.0.0/16"
  tags = {
    Name = "wp-vpc"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "48.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public_a"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "48.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private_a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "48.0.3.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public_b"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.wordpress_vpc.id
  cidr_block        = "48.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "private_b"
  }
}
# Internet Gateway for wp-vpc
resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wp-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.wordpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.wp_igw.id
  }

  # The local route is automatically created by AWS; no need to define it manually.

  tags = {
    Name = "public-rtb"
  }
}

# Associate public_a subnet with public route table
resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rtb.id
}

# Associate public_b subnet with public route table
resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rtb.id
}
