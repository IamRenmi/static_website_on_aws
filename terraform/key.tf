resource "aws_key_pair" "wordpress_key" {
  key_name   = "my-key"
  public_key = file("../keys/0427-wordpress.pem")
}

resource "aws_key_pair" "bastion_key" {
  key_name   = "my-key"
  public_key = file("../keys/0427-bastion.pem")
}