#!/bin/bash

function dowloadFont
{
	echo -e "\nDownloading JetBrains Mono font...\n"	
	wget --output-document "JetBrainsMono.zip" "https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip?_gl=1*1ge3a6s*_ga*NTI0NTEzOTU0LjE2NTg4Mjg2MzI.*_ga_9J976DJZ68*MTY1ODgyODYzMi4xLjAuMTY1ODgyODYzMi4w&_ga=2.58108778.1542459134.1658828632-524513954.1658828632"
	unzip "JetBrainsMono.zip" -d JetBrainsMono/
	rm JetBrainsMono.zip
}

function installFont
{
	mkdir ~/.fonts
	mv ./JetBrainsMono/fonts/ttf/*.ttf ~/.fonts
	echo -e "$(tput setaf 2) \nJetBrainsMono installed!\n" 
	# echo -e "\nJetBrainsMono installed!\n"
	rm -r JetBrainsMono
}

function makeSymbolicsLinks
{
	ln -s ./.dotfiles/.zshrc ~/.zshrc 
	ln -s ./.dotfiles/.bashrc ~/.bashrc
}

function loadGnomeSettings
{
	dconf load / < ./dconf-seetings/gnome-seetings.ini
}

function enableSnapd	
{
	sudo pacman -S snapd
	sudo systemctl enable --now snapd.socket
	sudo ln -s /var/lib/snapd/snap /snap
}

function enableExtenstions
{
	# Enables desktop icons
	# https://extensions.gnome.org/extension/2087/desktop-icons-ng-ding/
	gnome-extensions enable "ding@rastersoft.com"
}

function installPackages
{
	sudo pacman --sync --refresh --sysupgrade	
	sudo pacman -S - < packagesList
}

function askForInstall
{
	echo -e "\n"
	read -p "Install default packages? (packageList)[y/n]: " yn

	case $yn in 
		[yY] ) echo -e "Installing packages...\n";
			   installPackages;;
			   # neofetch;;

		[nN] ) 	echo -e "$(tput setaf 2)\nFinished!\n";; #echo -e "\nFinished!\n";;

		* ) echo "invalid response";
			askForInstall;;
	esac
}

function runSetup
{
	echo -e "\nRunning setup...\n"

	dowloadFont
	installFont

	makeSymbolicsLinks
	loadGnomeSettings
	askForInstall
}

runSetup
