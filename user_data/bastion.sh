#!/bin/bash
sudo yum update -y
# Install MariaDB 10.5
sudo yum install -y mariadb105

# Enable and start MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb
