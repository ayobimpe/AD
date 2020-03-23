id $USER_VAR
echo "                                                 "
echo "+++++++++++++++++++++++++++ # Backup files +++++++++++++++++++++++++++++++"
sudo cp -p /etc/cloud/cloud.cfg /etc/cloud/cloud.cfg_bkp
sudo cp -p /etc/hostname /etc/hostname_bkp
sudo cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bkp
sudo cp -p /etc/hosts /etc/hosts_bkp
sudo cp -p /etc/sssd/sssd.conf /etc/sssd/sssd.conf_bkp
sudo cp -p /etc/sudoers /etc/sudoers_bkp
sudo cp -pR /etc/sudoers.d /etc/sudoers.d_bkp
echo "                                                 "
echo "++++++++++++++++++ # Hostname is preserved between restarts/reboots in cloud.cfg +++++++++++++++++++++++"
sudo sh -c 'echo -e "\npreserve_hostname: true" >> /etc/cloud/cloud.cfg'
sudo cat /etc/cloud/cloud.cfg |grep preserve_hostname
echo "                                                 "
echo "++++++++++++++++++++++# PasswordAuthentication set to YES in sshd_config +++++++++++++++++++++++++"
sudo sed -i '/#PasswordAuthentication yes/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sudo cat /etc/ssh/sshd_config |grep PasswordAuthentication
sudo sed -i '/PasswordAuthentication no/c\#PasswordAuthentication no' /etc/ssh/sshd_config
sudo cat /etc/ssh/sshd_config |grep PasswordAuthentication
echo "                                                 "
echo "++++++++++++++++++++++++ # use_fully_qualified_names set to FALSE in sssd.conf +++++++++++++++++++++"
sudo sed -i '/use_fully_qualified_names = True/c\use_fully_qualified_names = False' /etc/sssd/sssd.conf
sudo cat /etc/sssd/sssd.conf |grep use_fully_qualified_names
sudo sed -i '/fallback_homedir = \/home\/%u@%d/c\fallback_homedir = \/home\/%u/' /etc/sssd/sssd.conf
sudo cat /etc/sssd/sssd.conf |grep fallback_homedir
sudo cat /etc/sssd/sssd.conf