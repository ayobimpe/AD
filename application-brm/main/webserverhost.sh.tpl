#!/bin/bash

#Install CLI
sudo yum install -y epel-release
sudo yum install -y python36 python36-pip
sudo pip3 install awscli --upgrade

#############################################################################################################################
#############################################################################################################################
 ***************** For WebServers: **************************
#############################################################################################################################

echo "+++++++++++++++++++# Set Local WebServer Hostname ++++++++++++++++++++++"
echo "========================================================================================="
HOST_VAR=$(aws ec2 describe-tags --region us-east-1 --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" --query 'Tags[?Key==`Name`].Value[]' --output text)
echo $HOST_VAR

echo " "
sudo hostnamectl set-hostname --static $HOST_VAR

echo " "
echo "++++++++++++ # Checking Host file for the Web server - $HOST_VAR ++++++++++++++++"
#IP_VAR=$(hostname -I)
#echo "$IP_VAR  $HOST_VAR  $HOST_VAR " | sudo tee -a /etc/hosts > /dev/null
sudo cat /etc/hosts

echo " "
echo "+++++++++++++++++++# Get First Database Server Hostname and IP Address ++++++++++++++++++++++"
echo "========================================================================================="
echo " ********** Getting IP-Address for First Web Server......."
BRMDB1_IP=$( aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep BRM-DbInstance1 | awk '{print $1}' | grep -v None)
echo $BRMDB1_IP

echo " "
echo " ********** Getting Hosname for First Web Server......."
BRMDB1_Host=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep -m1 BRM-DbInstance1 | awk '{print $2}')
echo $BRMDB1_Host

echo " "
echo "+++++++++++++++++++# Get Second Web Server Hostname and IP Address ++++++++++++++++++++++"
echo "========================================================================================="
BRMDB2_IP=$( aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep BRM-DbInstance2 | awk '{print $1}' | grep -v None)
echo $BRMDB2_IP

BRMDB2_Host=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep -m1 BRM-DbInstance2 | awk '{print $2}')
echo $BRMDB2_Host

echo " "
echo " "
echo "++++++++++++ # Update Host file with Database and WebServers information - $HOST_VAR ++++++++++++++++"
echo "========================================================================================="
IP_VAR=$(hostname -I)
echo "$IP_VAR  $HOST_VAR  $HOST_VAR " | sudo tee -a /etc/hosts > /dev/null
echo "$BRMDB1_IP  $BRMDB1_Host  $BRMDB1_Host " | sudo tee -a /etc/hosts > /dev/null
echo "$BRMDB2_IP  $BRMDB2_Host  $BRMDB2_Host " | sudo tee -a /etc/hosts > /dev/null
sudo cat /etc/hosts