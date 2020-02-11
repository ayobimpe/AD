#!/bin/bash

#############################################################################################################################
#############################################################################################################################
 ***************** For Database Servers: **************************
#############################################################################################################################

echo "+++++++++++++++++++# Set Local Database Server Hostname ++++++++++++++++++++++"
echo "========================================================================================="
HOST_VAR=$(aws ec2 describe-tags --region us-east-1 --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" --query 'Tags[?Key==`Name`].Value[]' --output text)
echo $HOST_VAR

echo " "
sudo hostnamectl set-hostname --static $HOST_VAR

echo " "
echo "+++++++++++++++++++# Get First Web Server Hostname and IP Address ++++++++++++++++++++++"
echo "========================================================================================="
echo " ********** Getting IP-Address for First Web Server......."
WebApp1_IP=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep App-Server | awk '{print $1}')
echo $WebApp1_IP

echo " "
echo " ********** Getting Hosname for First Web Server......."
WebApp1_Host=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep App-Server | awk '{print $2}')
echo $WebApp1_Host

# echo " "
# echo "+++++++++++++++++++# Get Second Web Server Hostname and IP Address ++++++++++++++++++++++"
# echo "========================================================================================="
# WebApp2_IP=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep WebApp2 | awk '{print $1}')
# echo $WebApp2_IP
#
# WebApp2_Host=$(aws ec2 describe-instances --query 'Reservations[].Instances[].{NameTag: Tags[?Key==`Name`].Value|[0], IPAdress: PrivateIpAddress}' --region us-east-1  --output text | grep WebApp2 | awk '{print $2}')
# echo $WebApp2_Host

echo " "
echo " "
echo "++++++++++++ # Update Host file with Database and WebServers information - $HOST_VAR ++++++++++++++++"
echo "========================================================================================="
IP_VAR=$(hostname -I)
echo "$IP_VAR  $HOST_VAR  $HOST_VAR " | sudo tee -a /etc/hosts > /dev/null
echo "$WebApp1_IP  $WebApp1_Host  $WebApp1_Host " | sudo tee -a /etc/hosts > /dev/null
#echo "$WebApp2_IP  $WebApp2_Host  $WebApp1_Host " | sudo tee -a /etc/hosts > /dev/null
sudo cat /etc/hosts