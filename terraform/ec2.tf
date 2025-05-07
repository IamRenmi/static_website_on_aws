resource "aws_instance" "bastion" {
  ami                         = "ami-0f88e80871fd81e91"
  instance_type               = "t2.micro"
  key_name                    = "bastion-key"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true

  user_data = file("../user_data/bastion.sh")

  tags = {
    Name = "bastion"
  }
}


resource "aws_instance" "wp_server" {
  ami                         = "ami-0f88e80871fd81e91"
  instance_type               = "t2.micro"
  key_name                    = "wp-key"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.wordpress_sg.id]
  associate_public_ip_address = true

  user_data = file("../user_data/userdata_initial_variable.sh")

  tags = {
    Name = "wp-server"
  }
}
