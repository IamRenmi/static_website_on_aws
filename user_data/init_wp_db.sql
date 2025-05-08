CREATE DATABASE wordpress;
CREATE USER 'wp-user'@'%' IDENTIFIED BY 'lab-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'%';
FLUSH PRIVILEGES;
