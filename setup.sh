#!/bin/bash

# Update
sudo apt-get update

# Users
echo -e "nothingyoucanguesslolgoaway\nnothingyoucanguesslolgoaway\n\n\n\n\n\n\n" | (sudo adduser jack)
echo -e "debug\ndebug\n\n\n\n\n\n\n" | (sudo adduser debug)

echo -e "nothingyoucanguesslolgoaway\nnothingyoucanguesslolgoaway" | (sudo passwd jack)
echo -e "debug\ndebug" | (sudo passwd debug)
echo -e "thisaswellyoucanneverguessnorbrute\nthisaswellyoucanneverguessnorbrute" | (sudo passwd root)
echo -e "goawaystopdonteventry\ngoawaystopdonteventry" | (sudo passwd vagrant)
echo -e "okayicantthinkofanythingelse\nokayicantthinkofanythingelse" | (sudo passwd ubuntu)

sudo adduser jack docker

# Install flask
sudo apt-get install -y python3 python3-pip build-essential

# Install ncat
cd /tmp
git clone https://github.com/nmap/nmap
cd nmap
./configure
make -j4
sudo make install
cd ..
rm -rf nmap

cd /vagrant_data

echo -e "sudo su jack\npython3 -m pip install Flask" | bash

# Move web folders
sudo mkdir /var/www
sudo cp -r webapp/* /var/www/

# Setup web service
sudo cp flask-web.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start flask-web.service
sudo systemctl enable flask-web.service

# VSFTPd
sudo apt-get install -y vsftpd
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
sudo cp vsftpd.conf /etc
sudo systemctl restart vsftpd
sudo mkdir -p /var/ftp/pub

# SETUID
sudo chmod +s /usr/bin/find

# Docker install
sudo apt-get install -y docker.io
sudo adduser jack docker
sudo docker pull ubuntu

# Flags
echo "CTF{3227d5ae229c013ed384e4f27dd5a616}" | sudo -u jack tee /home/jack/user.txt
echo "CTF{614f6a949901690d67bc5d984cbc969e}" | sudo tee /root/root.txt
