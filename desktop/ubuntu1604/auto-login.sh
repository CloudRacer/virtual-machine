#!/bin/sh

# https://forum.ubuntuusers.de/post/8216143/quote/

AUTO_LOGIN_USERNAME=vagrant
DM_FOLDER=/etc/lightdm
DM_CONFIG_FOLDER=$DM_FOLDER/lightdm.conf.d
DM_CONFIG_FILE=$DM_CONFIG_FOLDER/autologin.conf

if [ ! -d "$DM_FOLDER" ]; then
    sudo mkdir $DM_FOLDER
fi
if [ ! -d "$DM_CONFIG_FOLDER" ]; then
    sudo mkdir $DM_CONFIG_FOLDER
fi
if [ ! -f "$DM_CONFIG_FILE" ]; then
    sudo touch $DM_CONFIG_FILE
fi

sudo sh -c "echo \"[Seat:*]\" >> $DM_CONFIG_FILE"
sudo sh -c "echo \"autologin-user=$AUTO_LOGIN_USERNAME\" >> $DM_CONFIG_FILE"
sudo sh -c "echo \"autologin-user-timeout=0\" >> $DM_CONFIG_FILE"
