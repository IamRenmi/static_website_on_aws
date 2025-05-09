resource "aws_instance" "setup_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group_ids

  tags = {
    Name = "setup-server"
  }

  user_data = base64encode(<<-EOF
#!/bin/bash
sudo su

# Update and prepare web root
yum update -y
mkdir -p /var/www/html
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${var.efs_mount_dns}:/ /var/www/html

# Install HTTPD and start service
yum install -y httpd httpd-tools mod_ssl
systemctl enable httpd
systemctl start httpd

# Install PHP and extensions
amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-common php-pear php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip}

# Install MySQL Server
rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install -y mysql-community-server
systemctl enable mysqld
systemctl start mysqld

# Reminder: Initialize RDS database separately
cat <<DBINIT
mysql -h ${var.db_endpoint} -P 3306 -u ${var.db_user} -p
CREATE DATABASE ${var.db_name};
CREATE USER '${var.db_user}'@'%' IDENTIFIED BY '${var.db_password}';
GRANT ALL PRIVILEGES ON ${var.db_name}.* TO '${var.db_user}'@'%';
FLUSH PRIVILEGES;
DBINIT

# Configure permissions
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www && find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
chown apache:apache -R /var/www/html

# Install WordPress
cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* .

# Configure wp-config.php
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${var.db_name}/" wp-config.php
sed -i "s/username_here/${var.db_user}/" wp-config.php
sed -i "s/password_here/${var.db_password}/" wp-config.php
sed -i "s/localhost/${var.db_endpoint}/" wp-config.php

# Restart HTTPD to apply changes
systemctl restart httpd
EOF
  )
}