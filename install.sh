#!/bin/bash

uname="monitor"
passwd="monitor"

if [ "$1" != "--exisiting" ] ; then
    # installing packages
    sudo apt install sysstat apache2 nginx nginx-core libcgi-pm-perl libjson-xs-perl libio-interface-perl

    # create monitor user adn add to staff group
    adduser $uname
    echo $uname:$passwd | sudo chpasswd
    sudo usermod -a -G staff monitor
fi

# copy scripts and service files
sudo cp -rf ./scripts /home/$uname
sudo cp -rf ./systemd-units/* /etc/systemd/system
sudo cp -rf ./cgi-bin /var/
sudo chgrp staff /var/cgi-bin/
sudo chown monitor /var/cgi-bin/

# copy configuration
sudo cp -f ./etc/apache2/ports.conf /etc/apache2/ports.conf
for apache2_site in ./etc/apache2/sites-avaliable/*; do
    sudo cp -f ./etc/apache2/sites-avaliable/$apache2_site /etc/apache2/sites-avaliable/
done

for nginx_site in ./etc/nginx/sites-avaliable/*; do
    sudo cp -f ./etc/apache2/sites-avaliable/$apache2_site /etc/nginx/sites-avaliable/
done

sudo ln -s /etc/nginx/sites-avaliable/monitor /etc/nginx/sites-enable/monitor

# acrivating apache2 modules
sudo ln -s /etc/apache2/mods-available/cgid.load /etc/apache2/mods-enabled/
sudo ln -s /etc/apache2/mods-available/cgid.conf /etc/apache2/mods-enabled/

# enabling it
for systemd_unit in ./systemd-units/*; do
    sudo systemctl enable $systemd_unit
done
