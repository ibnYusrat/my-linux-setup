# Automatic setup script for Linux (Debian based distros with gnome)

I run this script on a fresh install of Linux, (Mostly Debian based distributions like Ubuntu or Pop!_OS etc) so that it sets everything up for me and I am ready to work..

When executed, it installs: 

* flatpak
* sshuttle
* synergy
* *Completely removes thunderbird*
* git, curl, nfs-common (used for network attached storage).
* zsh (with `oh-my-zsh` and `powerlevel10k` theme)
* lua 5.1 and z.lua (super fast directory navigation tool)
* PopOS Animated Splash Screen (Looks like this: https://www.reddit.com/r/pop_os/comments/jwn4se/psa_pop_os_boot_popup_logo/)
* nautilus (with typeahead support)
* openssh-server
* alacritty terminal
* nvm (node version manager) and latest LTS version of NodeJS and NPM
* zerotier-cli 
* vim
* GIMP (flatpak)
* lm-sensors
* gnome-tweak-tool
* docker
* Chromium Browser
* prerequisites of Gnome shell extensions
* WebStorm (flatpak)
* Android Studio (flatpak)
* WhiteSur GTK+Icon theme.

And finally upgrades all the packages in the system to the latest versions.

To run the script, simply type `sudo -i` enter your password. Navigate to the directory where you cloned the repository and then run `./script.sh`.
After the script runs you should run `chsh` in terminal and after entering your password, type: `/bin/zsh` to change shell from Bash to ZSH. Then restart the computer for the change to take effect. Once you restart and open terminal, you will be prompted to configure the `powerlevel0k` theme. Just follow the prompts and set according to your liking.

To get the right font in gnome-terminal, you'll need to go to its preferences and uncheck the custom font checkbox, then open gnome-tweak-tool and under the monotype font, select: MesloLGS NF. This way the icons will look super nice. Alternately you can just use the `alacrity` terminal and that would probably look OK automatically.

Of course this exact list of softwares isn't probably what fit your needs, but you can fork this repo and use it as a template to adjust based on your own needs.


