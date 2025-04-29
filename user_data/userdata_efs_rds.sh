#!/bin/bash
# System update
sudo yum update -y

# Variables
WORDPRESS_DIR="/var/www/html"     # wordpress code directory

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
# moount to /var/www/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-07339622de7c67939.efs.eu-central-1.amazonaws.com:/ /var/www/html/
# ensures the EFS is mounted at boot time
echo "fs-07339622de7c67939.efs.eu-central-1.amazonaws.com:/ /var/www/html/ nfs defaults,_netdev 0 0" | sudo tee -a /etc/fstab
# echo "fs-07339622de7c67939.efs.eu-central-1.amazonaws.com:/ /var/www/html nfs defaults,_netdev 0 0" >> /etc/fstab
# Test the mount
mount -a

# Download and install wordpress
# download wordpress
wget https://wordpress.org/latest.tar.gz
# unzip wordpress
sudo tar -xvzf latest.tar.gz
# move wp content to /var/www/html
sudo mv wordpress/* /var/www/html/

# set correct permission for user
# Ensure apache:apache ownership recursively for the entire WordPress directory
sudo chown -R apache:apache /var/www/html/
# Set directory permissions to 775 recursively
sudo find /var/www/html/ -type d -exec chmod 775 {} \;
# Set file permissions to 664 recursively
sudo find /var/www/html/ -type f -exec chmod 664 {} \;
# Ensure ec2-user is in the apache group (run again to be safe)
sudo usermod -a -G apache ec2-user
sudo chown -R apache:apache /var/www/html/wp-content
sudo find /var/www/html/wp-content -type d -exec chmod 775 {} \;
sudo find /var/www/html/wp-content -type f -exec chmod 664 {} \;


# Create a WordPress configuration file from the sample
sudo cp wp-config-sample.php wp-config.php

# change DB connection to wp-config
sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/wp_user/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/lab-password/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/wp-db.cfkie6c86npc.eu-central-1.rds.amazonaws.com/" /var/www/html/wp-config.php

# change max upload size
sudo sed -i "s/^;*\(upload_max_filesize\s*=\s*\).*$/\164M/" "/etc/php.ini"
sudo sed -i "s/^;*\(post_max_size\s*=\s*\).*$/\164M/" "/etc/php.ini"
sudo sed -i "s/^;*\(memory_limit\s*=\s*\).*$/\1128M/" "/etc/php.ini"

#restart services
sudo systemctl restart php-fpm
sudo systemctl restart httpd