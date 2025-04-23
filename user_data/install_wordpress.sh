#!/bin/bash
sudo yum update -y

# add swap file to prevent memory exhaustion
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# variables
DB_NAME="wordpress_db"            # Name of the database
DB_USER="wp_user"            # Database username
DB_PASSWORD="lab-password"      # Database password
WORDPRESS_DIR="/var/www/html"     # wordpress code directory

# Install expect package
sudo yum install expect -y

# Install and enable httpd Apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Installing PHP
sudo yum install -y php php-{mysqlnd,fpm,xml,mbstring} -y
sudo systemctl enable php-fpm
sudo systemctl start php-fpm
# restart httpd
sudo systemctl restart httpd

# Install and enable MariaDB server
sudo yum install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb
sudo systemctl restart mariadb

sleep 10
# Secure the MariaDB installation
echo "Securing MariaDB installation..."
expect - <<EOF
spawn mysql_secure_installation
expect "Enter current password for root (enter for none):"
send "\r"
expect "Set root password?"
send "y\r"
expect "New password:"
send "$DB_PASSWORD\r"
expect "Re-enter new password:"
send "$DB_PASSWORD\r"
expect "Remove anonymous users?"
send "y\r"
expect "Disallow root login remotely?"
send "y\r"
expect "Remove test database and access to it?"
send "y\r"
expect "Reload privilege tables now?"
send "y\r"
expect eof
EOF
echo "MariaDB installation secured."

# Create the WordPress database
sudo mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME;"
sudo mysql -u root -p$DB_PASSWORD -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
sudo mysql -u root -p$DB_PASSWORD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';"
sudo mysql -u root -p$DB_PASSWORD -e "FLUSH PRIVILEGES;"

# Download and install Wordpress
cd /home/ec2-user
wget https://wordpress.org/latest.tar.gz
sudo tar -xvzf latest.tar.gz
sudo mv wordpress/* ${WORDPRESS_DIR}

# Change ownership of the web directory
sudo chown -R apache:apache ${WORDPRESS_DIR}/*
sudo chmod -R 755 ${WORDPRESS_DIR}/*
#sudo find ${WORDPRESS_DIR} -type f -exec chmod 644 {} \;



# Change to the WordPress directory
cd ${WORDPRESS_DIR}

# Create a WordPress configuration file from the sample
sudo cp wp-config-sample.php wp-config.php
sudo rm -f ${WORDPRESS_DIR}/index.html

# Replace DB placeholders with your actual variables
sed -i "s/database_name_here/${DB_NAME}/" ${WORDPRESS_DIR}/wp-config.php
sed -i "s/username_here/${DB_USER}/" ${WORDPRESS_DIR}/wp-config.php
sed -i "s/password_here/${DB_PASSWORD}/" ${WORDPRESS_DIR}/wp-config.php
sed -i "s/localhost/localhost/" ${WORDPRESS_DIR}/wp-config.php

# Restart Apache
sudo systemctl restart httpd