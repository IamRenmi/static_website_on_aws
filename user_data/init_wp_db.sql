mysql -h wp-db.c9gaagom6hb0.eu-west-3.rds.amazonaws.com -P 3306 -u admin -p
CREATE DATABASE wordpress;
CREATE USER 'wp-user'@'%' IDENTIFIED BY 'lab-password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp-user'@'%';
FLUSH PRIVILEGES;
