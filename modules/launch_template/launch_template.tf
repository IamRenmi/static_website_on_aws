resource "aws_launch_template" "wp" {
  name_prefix             = "wp-template-"
  image_id                = var.ami_id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [var.security_group_id]

  user_data = base64encode(<<-EOF
#!/bin/bash
set -e

yum update -y
# Install HTTPD, SSL and start
yum install -y httpd httpd-tools mod_ssl
systemctl enable httpd
systemctl start httpd

# Install PHP 7.4 and extensions
amazon-linux-extras enable php7.4
yum clean metadata
yum install -y php php-common php-pear \
  php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip}

# Install MySQL server
rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install -y mysql-community-server
systemctl enable mysqld
systemctl start mysqld

# Mount EFS via fstab
echo "${var.efs_mount_dns}.efs.${var.region}.amazonaws.com:/ /var/www/html nfs4 \
  nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 0 0" | sudo tee -a /etc/fstab
mount -a

# Ensure apache owns web root
chown apache:apache -R /var/www/html

echo "Launch template wp-template configured."
EOF
  )
}