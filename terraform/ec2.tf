resource "aws_instance" "wordpress" {
  ami           = "ami-05572e392e80aee89" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  key_name      = "vockey"  

  user_data = file("../user_data/install_wordpress.sh")

  tags = {
    Name = "WordPress-Server-userdata-modified"
  }
}