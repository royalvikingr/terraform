#!/bin/bash
# Install updates
sudo yum update -y
# Install Apache server, PHP and necessary tools
sudo yum install -y httpd php php-mysqlnd unzip stress

# Set database variables; NOT WORKING
DBName=$(db_name)
DBUser=$(db_username)
DBPassword=$(db_username)
DBEndpoint=$(db_endpoint)

# Start Apache server and enable it on system startup
sudo systemctl start httpd
sudo systemctl enable httpd

# Download and install Wordpress, then clean up
wget http://wordpress.org/latest.tar.gz -P /var/www/html
cd /var/www/html
tar -zxvf latest.tar.gz 
cp -rvf wordpress/* . 
rm -R wordpress 
rm latest.tar.gz

# Configure WP to use the database, making changes to the wp-config.php file, setting the DB name
cp ./wp-config-sample.php ./wp-config.php # rename the file from sample to clean
sed -i "s/'database_name_here'/'$DBName'/g" wp-config.php 
sed -i "s/'username_here'/'$DBUser'/g" wp-config.php 
sed -i "s/'password_here'/'$DBPassword'/g" wp-config.php
sed -i "s/'localhost'/'$DBEndpoint'/g" wp-config.php

# Configure web server permissions
usermod -a -G apache ec2-user 
chown -R ec2-user:apache /var/www 
chmod 2775 /var/www 
find /var/www -type d -exec chmod 2775 {} \; 
find /var/www -type f -exec chmod 0664 {} \; 