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
# Check if EFS is already mounted (optional but good practice)
if ! mountpoint -q $WORDPRESS_DIR; then
  echo "Mounting EFS..."
  sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS_ENDPOINT $WORDPRESS_DIR/
  # Add to fstab only if not already present
  if ! grep -q "$EFS_DNS_ENDPOINT" $FILE_SYSTEM_TABLE; then
      echo "$EFS_DNS_ENDPOINT $WORDPRESS_DIR/ nfs defaults,_netdev 0 0" | sudo tee -a $FILE_SYSTEM_TABLE
  fi
  # Ensure fstab mounts are processed
  sudo mount -a
else
  echo "EFS is already mounted."
fi

# Check if WordPress is already installed in the directory
if [ ! -f "$WORDPRESS_DIR/wp-config.php" ]; then
  echo "WordPress not found, performing initial installation..."
  # Download and install WordPress
  wget $WORDPRESS_URL -O /tmp/latest.tar.gz # Download to a temp location
  sudo tar -xvzf /tmp/latest.tar.gz -C /tmp/ # Extract to a temp location
  sudo mv /tmp/wordpress/* $WORDPRESS_DIR/ # Move files to EFS

  # Create WordPress config file - ONLY if not existing
  sudo cp $WORDPRESS_DIR/wp-config-sample.php $WORDPRESS_DIR/wp-config.php
  sudo sed -i "s/database_name_here/$WORDPRESS_DB/" $WORDPRESS_DIR/wp-config.php
  sudo sed -i "s/username_here/$WORDPRESS_DB_USER/" $WORDPRESS_DIR/wp-config.php
  sudo sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" $WORDPRESS_DIR/wp-config.php
  sudo sed -i "s/localhost/$DB_ENDPOINT/" $WORDPRESS_DIR/wp-config.php

  echo "Initial WordPress installation complete."
else
  echo "Existing WordPress installation found on EFS. Skipping download and config creation."
fi

# Set correct permission for user
sudo chown -R apache:apache $WORDPRESS_DIR/
sudo find $WORDPRESS_DIR/ -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/ -type f -exec chmod 664 {} \;
sudo usermod -a -G apache ec2-user
sudo chown -R apache:apache $WORDPRESS_DIR/wp-content
sudo find $WORDPRESS_DIR/wp-content -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/wp-content -type f -exec chmod 664 {} \;

# Change PHP limits (Apply every time for consistency)
# Ensure PHP_INIT variable is correctly set
if [ -f "$PHP_INIT" ]; then
    sudo sed -i "s/^;*\(upload_max_filesize\s*=\s*\).*$/$UPLOAD_MAX_FILESIZE/" "$PHP_INIT"
    sudo sed -i "s/^;*\(post_max_size\s*=\s*\).*$/$POST_MAX_SIZE/" "$PHP_INIT"
    sudo sed -i "s/^;*\(memory_limit\s*=\s*\).*$/$MEMORY_LIMIT/" "$PHP_INIT"
    echo "PHP limits updated."
else
    echo "PHP INI file not found at $PHP_INIT. Skipping PHP limit changes."
fi

# Restart services
sudo systemctl restart php-fpm
sudo systemctl restart httpd
