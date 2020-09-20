# My automatic setup script for Linux (Debian based distros with gnome)

I run this script on a fresh install of Linux, so that it sets everything up for me.

When executed, it installs: 

* flatpak
* sshuttle
* synergy
* *Completely removes thunderbird*
* git, curl, nfs-common (used for network attached storage).
* nautilus (with typeahead support)
* nvm (node version manager)
* zerotier-cli 
* vim
* GIMP
* lm-sensors
* gnome-tweak-tool
* docker
* google-chrome-stable
* prerequisites of Gnome shell extensions
* webstorm (using flatpak)
* androidstudio (using flatpak)

And finally upgrades all the packages in the system to the latest versions.

Of course this exact list of softwares isn't probably what fit your needs, but you can fork this repo and use it as a template to adjust based on your own needs.
