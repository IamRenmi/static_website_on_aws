resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "sg for bastion host"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    description = "allow ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "bastion-sg"  # Note: Tag value says "wordpress-sg"—confirm if that's intentional
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "sg for efs file share"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    description     = "allow nfs connection from wordpress instance"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "efs-sg"
  }
}


resource "aws_security_group" "wordpress_sg" {
  name        = "wordpress-sg"
  description = "sg for wordpress instance"
  vpc_id      = aws_vpc.wordpress_vpc.id

  # Rule 1: Allow HTTP from ELB SG
  ingress {
    description     = "allow HTTP traffic from elastic load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  # Rule 2: Allow HTTPS from ELB SG
  ingress {
    description     = "allow HTTPS traffic from elastic load balancer"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  # Rule 3: Allow SSH from bastion SG
  ingress {
    description     = "allow ssh from bastion host"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  tags = {
    Name = "wordpress-sg"
  }
}

resource "aws_security_group" "wp_public_sg" {
  name        = "wp-public-sg"
  description = "sg for wordpress instance with public access"
  vpc_id      = aws_vpc.wordpress_vpc.id

  # Rule 4: Allow SSH from anywhere
  ingress {
    description = "allow ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule 5: Allow HTTP from anywhere
  ingress {
    description = "allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Rule 6: Allow HTTPS from anywhere
  ingress {
    description = "allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  

  tags = {
    Name = "wp-public-sg"
  }
}


resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "sg for bastion host"
  vpc_id      = aws_vpc.wordpress_vpc.id

  # Allow MySQL/Aurora from WordPress SG
  ingress {
    description     = "allow db connection from wordpress instance"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  # Allow MySQL/Aurora from Bastion SG
  ingress {
    description     = "allow db connection from wordpress instance"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}


resource "aws_security_group" "elb_sg" {
  name        = "elb-sg"
  description = "sg for elastic load balancer"
  vpc_id      = aws_vpc.wordpress_vpc.id

  ingress {
    description = "allow http connection from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow https connection from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb-sg"
  }
}
