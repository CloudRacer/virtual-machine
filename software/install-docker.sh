#!/bin/sh

echo
echo
echo
echo Installing Docker...
echo
echo
echo

# Install.
#sudo apt-get -y install docker.io
# DOCKER SHOULD BE PROVISIONED USING THIS ENTRY IN THE Vagrantfile:
#   config.vm.provision "docker"

# Start Docker on boot-up.
sudo systemctl enable docker
# Start Docker now.
sudo systemctl start docker
