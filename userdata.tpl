#!/bin/bash
yum update -y
yum install httpd -y
systemctl enable httpd
systemctl start httpd
echo "TEST WEB PAGE" > /var/www/html/index.html
