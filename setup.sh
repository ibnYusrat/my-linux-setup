#!/bin/bash

RED='\033[0;31m';
NC='\033[0m'; # No Color
GREEN='\033[0;32m';
YELLOW='\033[1;33m';

CWD=`pwd`;

delay_after_message=3;

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

SSH_KEYS=./dot.ssh.zip
if [ -f "$SSH_KEYS" ]; then
    printf "${YELLOW}Installing SSH Keys${NC}\n";
    sleep $delay_after_message;
    run_as_user "rm -rf /home/ibnyusrat/.ssh"
    run_as_user "unzip ${SSH_KEYS} -d /home/${target_user}/"
    apt install sshuttle -y
    run_as_user "echo 'sshuttle_vpn() {' >> /home/${target_user}/.bashrc";
    run_as_user "echo '	remoteUsername='user';' >> /home/${target_user}/.bashrc";
    run_as_user "echo '	remoteHostname='hostname.com';' >> /home/${target_user}/.bashrc";
    run_as_user "echo '	sshuttle --dns --verbose --remote \$remoteUsername@\$remoteHostname --exclude \$remoteHostname 0/0' >> /home/${target_user}/.bashrc";
    run_as_user "echo '}' >> /home/${target_user}/.bashrc";
else
	printf "${RED}Zip file containing SSH Keys (dot.ssh.zip) was not found in the script directory, therefore keys were not installed ${NC}\n";
	sleep 10;
fi

REQUIRED_PKG="flatpak"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG|grep "install ok installed")
echo Checking for $REQUIRED_PKG: $PKG_OK
if [ "" = "$PKG_OK" ]; then
	printf "${YELLOW}Flatpak is not installed. Installing..${NC}\n";
	sleep $delay_after_message;
	apt update -y
	apt install flatpak -y
	apt install gnome-software-plugin-flatpak -y
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	printf "${GREEN}flatpak was installed, but requires a restart. ${NC}\nPlease reboot your computer and run this script again to proceed.\n"
	exit 1;
fi

apt update;

SYNERGY_DEB=./synergy_1.11.0.rc2_amd64.deb
if [ -f "$SYNERGY_DEB" ]; then
    printf "${YELLOW}Installing Synergy${NC}\n";
    sleep $delay_after_message;
    dpkg -i ./$SYNERGY_DEB;
    apt-get install -fy;
fi



# Remove thunderbird
printf "${RED}Removing thunderbird completely${NC}\n";
sleep $delay_after_message;
apt-get purge thunderbird* -y

# Some basic shell utlities
printf "${YELLOW}Installing git, curl and nfs-common.. ${NC}\n";
sleep $delay_after_message;
apt install git -y
apt install curl -y
apt install nfs-common -y

printf "${YELLOW}Installing stacer.. ${NC}\n";
sleep $delay_after_message;
apt install stacer -y

# Enable Nautilus type-head (instead of search):
printf "${YELLOW}Enabling nautilus typeahead${NC}\n";
sleep $delay_after_message;
add-apt-repository ppa:lubomir-brindza/nautilus-typeahead -y

#Install Node Version Manager
printf "${YELLOW}Installing Node Version Manager${NC}\n";
sleep $delay_after_message;
run_as_user "wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash";

#Install zerotier-cli
printf "${YELLOW}Installing zerotier-cli${NC}\n";
sleep $delay_after_message;
curl -s https://install.zerotier.com | bash

#Install VIM
printf "${YELLOW}Installing VIM${NC}\n";
sleep $delay_after_message;
apt install vim -y

#Install GIMP
printf "${YELLOW}Installing GIMP${NC}\n";
sleep $delay_after_message;
run_as_user "flatpak install org.gimp.GIMP -y"

#lm-sensors
printf "${YELLOW}Installing lm-sensors${NC}\n";
sleep $delay_after_message;
apt install lm-sensors -y
sensors-detect --auto

# Gnome tweak tool
printf "${YELLOW}Installing gnome-tweak-tool${NC}\n";
sleep $delay_after_message;
apt install gnome-tweak-tool -y;

#Docker
printf "${YELLOW}Installing Docker ${NC}\n";
sleep $delay_after_message;
apt install docker.io -y
systemctl enable --now docker
usermod -aG docker $target_user;

#Install Open-SSH Server
printf "${YELLOW}Installing Docker ${NC}\n";
sleep $delay_after_message;
apt install openssh-server -y
systemctl enable ssh
systemctl start ssh

#Install Chromium
print "${YELLOW}Installing chromium-browser${NC}\n";
sleep $delay_after_message;
apt install chromium-browser -y

#Change Theme to WhiteSur Dark
#Install Chromium
print "${YELLOW}Installing WhiteSur-dark theme${NC}\n";
sleep $delay_after_message;
run_as_user "mv white-sur-wallpaper.png ~/Pictures";
run_as_user "gsettings set org.gnome.desktop.background picture-uri file:////home/${target_user}/Pictures/white-sur-wallpaper.jpg";
run_as_user "unzip WhiteSur-dark.zip -d /home/${target_user}/.themes/";
run_as_user "unzip WhiteSur-icons.zip -d /home/${target_user}/.icons/";
run_as_user "gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-dark'";
run_as_user "gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'";
print "${YELLOW}WhiteSur was installed, but for better results, download the User Themes gnome extension and use the tweak tool to change shell theme to WhiteSur as well.${NC}\n";
sleep $delay_after_message;




printf "${YELLOW}Install prerequisits for Gnome Shell Extentions${NC}\n";
sleep $delay_after_message;
apt install gnome-shell-extensions -y
apt install chrome-gnome-shell -y


printf "${GREEN}Basic settings done, proceeding to install bigger softwares (Like WebStorm, Android Studio etc) using flatpak${NC}\n";
sleep $delay_after_message;

run_as_user "flatpak install webstorm -y";
run_as_user "flatpak install androidstudio -y";


apt dist-upgrade -y;
