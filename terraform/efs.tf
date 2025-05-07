# EFS File System
resource "aws_efs_file_system" "wp_efs" {
  creation_token = "wp-efs"
  encrypted      = true
  
  tags = {
    Name = "wp-efs"
  }
}

# Mount Target in us-east-1a (private_a)
resource "aws_efs_mount_target" "wp_efs_a" {
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = aws_subnet.private_a.id
  security_groups = [aws_security_group.efs_sg.id]
}

# Mount Target in us-east-1b (private_b)
resource "aws_efs_mount_target" "wp_efs_b" {
  file_system_id  = aws_efs_file_system.wp_efs.id
  subnet_id       = aws_subnet.private_b.id
  security_groups = [aws_security_group.efs_sg.id]
}
