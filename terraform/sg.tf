data "aws_security_group" "web_sg" {
  # Reference to existing Web security group
  vpc_id = data.aws_vpc.lab_vpc.id
  name   = "Web Security Group"  # Update with your actual security group name
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Security group for RDS instance allowing connection from Linux Server"
  vpc_id      = data.aws_vpc.lab_vpc.id

  # MySQL port access from web security group
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.web_sg.id]
  }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

  tags = {
    Name = "rds-sg"
  }
}