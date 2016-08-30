#!/bin/sh

# https://forum.ubuntuusers.de/post/8216143/quote/

AUTO_LOGIN_USERNAME=vagrant
DM_CONFIG_FOLDER=/etc/lightdm/lightdm.conf.d
DM_CONFIG_FILE=$DM_CONFIG_FOLDER/autologin.conf

sudo mkdir $DM_CONFIG_FOLDER
sudo touch $DM_CONFIG_FILE

sudo sh -c "echo \"[Seat:*]\" >> $DM_CONFIG_FILE"
sudo sh -c "echo \"autologin-user=$AUTO_LOGIN_USERNAME\" >> $DM_CONFIG_FILE"
sudo sh -c "echo \"autologin-user-timeout=0\" >> $DM_CONFIG_FILE"
