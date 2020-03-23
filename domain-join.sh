/home/ec2-user/.testdomain_join.sh
-----------------------------------------
#!/bin/bash
DATE=`date +%Y%m%d%R`
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/home/ec2-user/joinAD_$DATE.out 2>&1
echo "                                  "
echo "+++++++++++++++++++ # Installing packages ++++++++++++++++++"
###sudo yum -y update
sudo yum -y install sssd realmd krb5-workstation oddjob oddjob-mkhomedir adcli samba-common-tools
sudo easy_install pip
sudo pip install pexpect
sudo pip install awscli
sudo yum install -y expect 
sudo yum install unzip wget -y
echo "                                                 "
echo "+++++++++++++++++++#Set SELinux to permissive mode +++++++++++++++++++++++"
sestatus | grep -i mode
sudo setenforce 0
sestatus | grep -i mode
===============
sudo vi /etc/selinux/config
SELINUX=permissive

===================
###aws ec2 describe-instances --query 'Reservations[].Instances[].Tags[?Key==`Name`].Value[]'
###HOST_VAR=$(aws ec2 describe-tags --region us-east-1 --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" --query 'Tags[*].Value' --output text) 
echo "                                                 "
echo "+++++++++++++++++++# Grab tag value with the 'describe-tags' action for setting server hostname ++++++++++++++++++++++"
HOST_VAR=$(aws ec2 describe-tags --region us-east-1 --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" --query 'Tags[?Key==`Name`].Value[]' --output text)
echo $HOST_VAR
================
echo "                                                 "
echo "+++++++++++++++++++++++++ # Joining To Domain ++++++++++++++++++++++++++++++++"
DOMAIN_VAR=domain.com
USER_VAR=username@domain.com
DOMAIN_ADMIN=ad_admin_group
sudo realm discover $DOMAIN_VAR --verbose
===============
###/usr/bin/expect -c  sudo /home/ec2-user/.joinad.sh
###sudo realm permit -g $DOMAIN_ADMIN
###sudo hostnamectl set-hostname --static $HOST_VAR
===============
echo "                                                 "
echo "++++++++++++++++++++++++++++++ # Modify Hosts file to get Differnet result for HOSTNAME and HOSTNAME -f +++++++++++++++++++++++++++++++"
IP_VAR=$(hostname -I)
echo "$IP_VAR  $HOST_VAR.$DOMAIN_VAR  $HOST_VAR " | sudo tee -a /etc/hosts > /dev/null
sudo cat /etc/hosts |grep domain.com
=================
###sudo realm join -U $USER_VAR $DOMAIN_VAR --verbose
###sudo realm join -U $USER_VAR $DOMAIN_VAR --verbose
####echo $passwd| realm join -U serviceaccount --client-software=sssd abc.com 