#From: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/install-LAMP.html

sudo yum update -y
sudo yum install -y httpd24 php70 mysql56-server php70-mysqlnd
sudo service httpd start
sudo chkconfig httpd on
sudo groupadd www
sudo usermod -a -G www ec2-user
exit
