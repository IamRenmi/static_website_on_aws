resource "aws_key_pair" "wordpress_key" {
  key_name   = "my-key"
  public_key = file("../keys/id_rsa.pub")
}