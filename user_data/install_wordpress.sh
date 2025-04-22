#!/bin/bash
yum update -y
yum install -y httpd mariadb105-server php php-mysqlnd php-fpm php-xml php-mbstring wget

systemctl start httpd
systemctl enable httpd

systemctl start mariadb
systemctl enable mariadb

# Secure MySQL install 
mysql -u root <<EOF
CREATE DATABASE wordpress;
CREATE USER 'wp_user'@'localhost' IDENTIFIED BY 'lab-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'localhost';
FLUSH PRIVILEGES;
EOF

cd /var/www/html
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wp_user/" wp-config.php
sed -i "s/password_here/your_password_here/" wp-config.php

chown -R apache:apache /var/www/html/*
chmod -R 755 /var/www/html/*

systemctl restart httpd
