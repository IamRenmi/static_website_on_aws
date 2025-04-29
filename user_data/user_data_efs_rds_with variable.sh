#!/bin/bash
# Variables
WORDPRESS_DIR="/var/www/html"
EFS_DNS_ENDPOINT="fs-07339622de7c67939.efs.eu-central-1.amazonaws.com:/"
FILE_SYSTEM_TABLE="/etc/fstab"
WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
PHP_INIT="/etc/php.ini"
DB_ENDPOINT="wp-db.cfkie6c86npc.eu-central-1.rds.amazonaws.com"
WORDPRESS_DB="wordpress"
WORDPRESS_DB_USER="wp_user"
WORDPRESS_DB_PASSWORD="lab-password"
UPLOAD_MAX_FILESIZE = "164M"
POST_MAX_SIZE="164M"
MEMORY_LIMIT="1128M"

# System update
sudo yum update -y

# Install all AMP Stack
# Apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
# Mariadb
sudo yum install mariadb105 -y
# PHP
sudo yum install php php-{mysqli,fpm,xml,mbstring} -y

# Mounting EFS
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS_ENDPOINT $WORDPRESS_DIR/
echo "$EFS_DNS_ENDPOINT $WORDPRESS_DIR/ nfs defaults,_netdev 0 0" | sudo tee -a $FILE_SYSTEM_TABLE
mount -a

# Download and install WordPress
wget $WORDPRESS_URL
sudo tar -xvzf latest.tar.gz
sudo mv wordpress/* $WORDPRESS_DIR/

# Set correct permission for user
sudo chown -R apache:apache $WORDPRESS_DIR/
sudo find $WORDPRESS_DIR/ -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/ -type f -exec chmod 664 {} \;
sudo usermod -a -G apache ec2-user
sudo chown -R apache:apache $WORDPRESS_DIR/wp-content
sudo find $WORDPRESS_DIR/wp-content -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/wp-content -type f -exec chmod 664 {} \;

# Create WordPress config file
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$WORDPRESS_DB/" $WORDPRESS_DIR/wp-config.php
sudo sed -i "s/username_here/$WORDPRESS_DB_USER/" $WORDPRESS_DIR/wp-config.php
sudo sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" $WORDPRESS_DIR/wp-config.php
sudo sed -i "s/localhost/$DB_ENDPOINT/" $WORDPRESS_DIR/wp-config.php

# Change PHP limits
sudo sed -i "s/^;*\(upload_max_filesize\s*=\s*\).*$/\$UPLOAD_MAX_FILESIZE/" "$PHP_INIT"
sudo sed -i "s/^;*\(post_max_size\s*=\s*\).*$/\$POST_MAX_SIZE/" "$PHP_INIT"
sudo sed -i "s/^;*\(memory_limit\s*=\s*\).*$/\$MEMORY_LIMIT/" "$PHP_INIT"

# Restart services
sudo systemctl restart php-fpm
sudo systemctl restart httpd
