resource "aws_instance" "wordpress" {
  ami           = "ami-0ce8c2b29fcc8a346" 
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.wordpress_sg.id]
  key_name = aws_key_pair.wordpress_key.key_name  

  user_data = file("../user_data/install_wordpress.sh")

  tags = {
    Name = "WordPress-Server-userdata1"
  }
}