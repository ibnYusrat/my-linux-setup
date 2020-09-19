#!/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[1;33m'

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run with sudo (sudo -i)" 
   exit 1
fi

read -p "Please enter your username: " target_user;

if id -u "$target_user" >/dev/null 2>&1; then
    echo "User $target_user exists! Proceeding.. ";
else
    echo 'The username you entered does not seem to exist.';
    exit 1;
fi


# function to run command as non-root user
run_as_user() {
	sudo -u $target_user bash -c "$1";
}

# run_as_user "touch test.txt"

REQUIRED_PKG="flatpak"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
	echo "${YELLOW}Flatpak is not installed. Installing..{NC}\n"
	sleep 1000;
	apt update -y
	apt install flatpak -y
	apt install gnome-software-plugin-flatpak -y
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	printf "${GREEN}flatpak was installed, but requires a restart. ${NC}\nPlease reboot your computer and run this script again to proceed.\n"
	exit 1;
fi

apt update;

FILE=./synergy_1.11.0.rc2_amd64.deb
if [ -f "$FILE" ]; then
    printf "${YELLOW}Installing Synergy${NC}\n";
    sleep 1000;
    dpkg -i ./synergy_1.11.0.rc2_amd64.deb;
    apt-get install -fy;
fi

# Remove thunderbird
printf "${RED}Removing thunderbird completely${NC}\n";
sleep 2000;
apt-get purge thunderbird* -y

# Some basic shell utlities
printf "${YELLOW}Installing git, curl and nfs-common.. ${NC}\n";
sleep 1000;
apt install git -y
apt install curl -y
apt install nfs-common -y

# Enable Nautilus type-head (instead of search):
printf "${YELLOW}Enabling nautilus typeahead${NC}\n";
sleep 1000;
add-apt-repository ppa:lubomir-brindza/nautilus-typeahead -y

#Install Node Version Manager
printf "${YELLOW}Installing Node Version Manager${NC}\n";
sleep 1000;
run_as_user "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash"
run_as_user "source ~/.bashrc"
run_as_user "nvm ls-remote"
run_as_user "nvm install --lts"
printf "${GREEN}"
run_as_user "node -v"
run_as_user "npm -v"
printf "${NC}\n"
sleep 2000;


#Install NodeJS used modules:
printf "${YELLOW}Installing @angular/cli:latest${NC}\n";
sleep 1000;
run_as_user "npm install -g @angular/cli"

printf "${YELLOW}Installing firebase-tools:latest${NC}\n";
sleep 1000;
run_as_user "npm install -g firebase-tools" 

#Install zerotier-cli
printf "${YELLOW}Installing zerotier-cli${NC}\n";
sleep 1000;
curl -s https://install.zerotier.com | bash

#Install Google Chrome
print "${YELLOW}Installing google-chrome-stable${NC}\n";
sleep 1000;
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
apt-get install -f


# Change keyboard shortcut for screenshot (CTRL + SHIFT + SUPER + 4 To change cursor and copy selection to clipboard
printf "${YELLOW}Mapping CTRL + SUPER + R-SHIFT + 4 to capture area of screen to clipboard. ${NC}\n";
sleep 1000;
GSETTINGS_SCHEMA=org.gnome.settings-daemon.plugins.media-keys
GSETTINGS_PATH=/org/gnome/settings-daemon/plugins/media-keys/
SCHEMA_PATH=$GSETTINGS_SCHEMA:$GSETTINGS_PATH
run_as_user "gsettings set $SCHEMA_PATH area-screenshot-clip '<Primary><Shift><Super>dollar'"

print "${YELLOW}Install prerequisits for Gnome Shell Extentions${NC}\n";
sleep 1000;
apt install gnome-shell-extensions -y
apt install chrome-gnome-shell -y


printf "${GREEN}Basic settings done, proceeding to install bigger softwares (Like WebStorm, Android Studio etc) using flatpak${NC}\n";
sleep 2000;
run_as_user "flatpak install webstorm -y";
run_as_user "flatpak install android-studio -y";


apt dist-upgrade -y;