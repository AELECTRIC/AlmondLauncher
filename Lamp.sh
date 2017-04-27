#!/bin/sh
#from: https://www.raspberrypi.org/learning/lamp-web-server-with-wordpress/worksheet/
#First install the apache2 package by typing the following command into the terminal:
sudo apt-get install apache2 -y
#Install the PHP and Apache packages with the following command:
sudo apt-get install php5 libapache2-mod-php5 -y
#Install the MySQL Server and PHP-MySQL packages by entering the following command into the terminal:
sudo apt-get install mysql-server php5-mysql -y
sudo service apache2 restart
#Navigate to /var/www/html/, and download WordPress to this location. You'll need to empty the folder 
#first (be sure to check you're not deleting files you need before running rm); change the ownership 
#of this folder to the pi user too
cd /var/www/html/
sudo rm *
sudo wget http://wordpress.org/latest.tar.gz
#Now extract the tarball, move the contents of the folder it extracted (wordpress) to the current directory
#and remove the (now empty) folder and the tarball to tidy up:
sudo tar xzf latest.tar.gz
sudo mv wordpress/* .
sudo rm -rf wordpress latest.tar.gz
#You should now change the ownership of these files to the Apache user
sudo chown -R www-data: .
