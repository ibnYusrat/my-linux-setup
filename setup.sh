#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run in interactive-root mode (sudo -i)" 
   exit 1
fi

read -p "Please enter your username: " target_user;

if id -u "$target_user" >/dev/null 2>&1; then
    echo "User $target_user exists! Proceeding.. ";
else
    echo 'The username you entered does not seem to exist.';
    exit 1;
fi

#apt update;
#apt upgrade;

#apt install flatpak
#apt install gnome-software-plugin-flatpak
