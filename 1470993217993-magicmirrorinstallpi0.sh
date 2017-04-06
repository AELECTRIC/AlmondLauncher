#!/usr/bin/env bash

# Define the tested version of Node.js. 
NODE_TESTED="v5.1.0"

#define helper methods.
function version_gt() { test "$(echo "$@" | tr " " "\n" | sort -V | head -n 1)" != "$1"; }
function command_exists () { type "$1" &> /dev/null ;}

# Installing helper tools
echo -e "\e[96mInstalling helper tools ...\e[90m"
sudo apt-get install curl wget git build-essential unzip || exit

# Check if we need to install or upgrade Node.js.
echo -e "\e[96mCheck current Node installation ...\e[0m"
NODE_INSTALL=false
if command_exists node; then
	echo -e "\e[0mNode currently installed. Checking version number.";
	NODE_CURRENT=$(node -v)
	echo -e "\e[0mMinimum Node version: \e[1m$NODE_TESTED\e[0m"
	echo -e "\e[0mInstalled Node version: \e[1m$NODE_CURRENT\e[0m"
	if version_gt $NODE_TESTED $NODE_CURRENT; then
    	echo -e "\e[96mNode should be upgraded.\e[0m"
    	NODE_INSTALL=true

    	#Check if a node process is currenlty running.
    	#If so abort installation.
    	if pgrep "node" > /dev/null; then
		    echo -e "\e[91mA Node process is currently running. Can't upgrade."
		    echo "Please quit all Node processes and restart the installer."
		    exit;
		fi

    else
    	echo -e "\e[92mNo Node.js upgrade nessecery.\e[0m"
	fi

else
	echo -e "\e[93mNode.js is not installed.\e[0m";
	NODE_INSTALL=true
fi

# Install or upgare node if nessecery.
if $NODE_INSTALL; then
	
	echo -e "\e[96mInstalling Node.js ...\e[90m"

	#Fetch the latest version of Node.js from the selected branch
	#The NODE_STABLE_BRANCH variable will need to be manually adjusted when a new branch is released. (e.g. 7.x)
	#Only tested (stable) versions are recommended as newer versions could break MagicMirror.
	
	NODE_STABLE_BRANCH="6.x"
	#curl -sL https://deb.nodesource.com/setup_$NODE_STABLE_BRANCH | sudo -E bash -
	#sudo apt-get install -y nodejs
	sudo apt-get remove nodejs
	sudo rm -rf /usr/local/{lib/node{,/.npm,_modules},bin,share/man}/{npm*,node*,man1/node*} /var/db/receipts/org.nodejs.*
	hash -r
	wget https://nodejs.org/dist/latest-v6.x/node-v6.2.2-linux-armv6l.tar.gz
	tar -xvf node-v6.2.2-linux-armv6l.tar.gz
	cd node-v6.2.2-linux-armv6l
	sudo cp -R * /usr/local/
	cd
	echo -e "\e[92mNode.js installation Done!\e[0m"
fi

#Install magic mirror
cd ~
if [ -d "$HOME/MagicMirror" ] ; then
	echo -e "\e[93mIt seems like MagicMirror is already installed."
	echo -e "To prevent overwriting, the installer will be aborted."
	echo -e "Please rename the \e[1m~/MagicMirror\e[0m\e[93m folder and try again.\e[0m"
	echo ""
	echo -e "If you want to upgrade your installation run \e[1m\e[97mgit pull\e[0m from the ~/MagicMirror directory."
	echo ""
	exit;
fi

echo -e "\e[96mCloning MagicMirror ...\e[90m"
if git clone https://github.com/MichMich/MagicMirror.git; then 
	echo -e "\e[92mCloning MagicMirror Done!\e[0m"
else
	echo -e "\e[91mUnable to clone MagicMirror."
	exit;
fi

cd ~/MagicMirror  || exit
echo -e "\e[96mInstalling dependencies ...\e[90m"
if npm install; then 
	echo -e "\e[92mDependencies installation Done!\e[0m"
else
	echo -e "\e[91mUnable to install dependencies!"
	exit;
fi

echo -e "\e[92mInstall KWe for jessie!\e[0m"
wget http://steinerdatenbank.de/software/kweb-1.7.3.tar.gz
tar -xzf kweb-1.7.3.tar.gz
cd kweb-1.7.3
./debinstall

echo -e "\e[92mConfig RPI\e[0m"
sudo touch /home/pi/MagicMirror/installers/start.sh
sudo echo 'cd ~/MagicMirror
node serveronly &
sleep 30
xinit /usr/bin/kweb -KJE4 “http://localhost:8080”' >> /home/pi/MagicMirror/installers/start.sh
sudo echo "/home/pi/MagicMirror/installers/start.sh" >> /home/pi/.bashrc

echo -e "\e[92mErase Package Download\e[0m"
sudo rm /home/pi/node-v6.2.2-linux-armv6l.tar.gz
sudo rm /home/pi/kweb-1.7.3.tar.gz
sudo rm /home/pi/kweb_about_c.html
sudo rm -rf /home/pi/node-v6.2.2-linux-armv6l
sudo rm -rf /home/pi/kweb-1.7.3
sudo rm /home/pi/ktop
sudo rm -rf /home/pi/youtube-dl

echo " "
echo -e "\e[92mWe're ready! Run \e[1m\e[97mDISPLAY=:0 npm start\e[0m\e[92m from the ~/MagicMirror directory to start your MagicMirror.\e[0m"
echo " "
echo " "
