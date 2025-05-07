mysql -h wp-db.cmpcgykywpz8.us-east-1.rds.amazonaws.com -P 3306 -u admin -p
CREATE DATABASE wordpress;
CREATE USER 'wp-user'@'%' IDENTIFIED BY 'lab-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'%';
FLUSH PRIVILEGES;
