#!/bin/bash
# Variables
WORDPRESS_DIR="/var/www/html"
EFS_DNS_ENDPOINT="fs-0f0b1ab44d85f3279.efs.eu-central-1.amazonaws.com:/"
FILE_SYSTEM_TABLE="/etc/fstab"
WORDPRESS_URL="https://wordpress.org/latest.tar.gz"
PHP_INIT="/etc/php.ini"
DB_ENDPOINT="wp-database.cfkie6c86npc.eu-central-1.rds.amazonaws.com"
WORDPRESS_DB="wordpress"
WORDPRESS_DB_USER="wp-user"
WORDPRESS_DB_PASSWORD="lab-password"
UPLOAD_MAX_FILESIZE="64M"
POST_MAX_SIZE="64M"
MEMORY_LIMIT="128M"

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
sudo yum install -y php php-{mysqlnd,fpm,xml,mbstring}


# Mounting EFS
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS_ENDPOINT $WORDPRESS_DIR/
sleep 5
echo "$EFS_DNS_ENDPOINT $WORDPRESS_DIR nfs4 defaults,_netdev 0 0" | sudo tee -a $FILE_SYSTEM_TABLE
if ! mountpoint -q "$WORDPRESS_DIR"; then
    echo "EFS mount failed!"
    exit 1
fi
mount -a

# Set correct permission for user
sudo chown -R apache:apache $WORDPRESS_DIR/
sudo find $WORDPRESS_DIR/ -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/ -type f -exec chmod 664 {} \;
sudo usermod -a -G apache ec2-user
sudo chown -R apache:apache $WORDPRESS_DIR/wp-content
sudo find $WORDPRESS_DIR/wp-content -type d -exec chmod 775 {} \;
sudo find $WORDPRESS_DIR/wp-content -type f -exec chmod 664 {} \;

# Change PHP limits
sudo sed -i "s/^.*upload_max_filesize.*/upload_max_filesize = $UPLOAD_MAX_FILESIZE/" "$PHP_INIT"
sudo sed -i "s/^.*post_max_size.*/post_max_size = $POST_MAX_SIZE/" "$PHP_INIT"
sudo sed -i "s/^.*memory_limit.*/memory_limit = $MEMORY_LIMIT/" "$PHP_INIT"


# Restart services
sudo systemctl restart php-fpm
sudo systemctl restart httpd