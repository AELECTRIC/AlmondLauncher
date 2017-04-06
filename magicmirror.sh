#!/bin/sh
sudo apt-get install xinit xserver-xorg
sudo apt-get install lxde-core
sudo apt-get install lightdm
sudo apt-get install git
sudo apt-get install libxss1
sudo apt-get install libnss3
sudo apt-get install unclutter
curl -sL https://raw.githubusercontent.com/MichMich/MagicMirror/master/installers/raspberry.sh | bash
cd ~/MagicMirror
npm install
cp config/config.js.sample config/config.js
cd ..
sudo npm install -g pm2
pm2 startup
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup linux -u pi --hp /home/pi"
cd ~
