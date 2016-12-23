#!/bin/bash

uname="monitor"
passwd="monitor"

# installing packages
sudo apt install sysstat apache2 nginx nginx-core libcgi-pm-perl libjson-xs-perl libio-interface-perl

# create monitor user
adduser $uname
echo $uname:$passwd | sudo chpasswd
sudo usermod -a -G staff monitor

# copy scripts and service files
sudo cp -rf ./scripts /home/$uname
sudo cp -rf ./systemd-units/* /etc/systemd/system
sudo cp ./cgi-bin /var/
sudo chgrp staff /var/cgi-bin/
sudo chown monitor /var/cgi-bin/

