#!/bin/bash
yum install -y httpd
systemctl start httpd.service

# install ansible for AWS
#sudo amazon-linux-extras install ansible2
#sudo useradd ansible -m 
#sudo usermod ansible -G wheel
