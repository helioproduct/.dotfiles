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
	echo -e "$(tput setaf 2)\nJetBrainsMono installed!\n$(tput sgr0)"
	rm -r JetBrainsMono
}

function makeSymbolicsLinks
{
	ln -s ./.dotfiles/.zshrc ~/.zshrc 
	ln -s ./.dotfiles/.bashrc ~/.bashrc
}

function addRussianLayout
{
	echo -e "\n"
	read -p "Add russian layout? [y/n]: " yn

	case $yn in 
		[yY] )
			cat ./dconf/russian-layout.ini >> ./dconf/gnome-settings.ini;;
		
		[nN] ) ;;
		
		* ) echo "invalid response";
			addRussianLayout;;
	esac
}

function loadGnomeSettings
{
	dconf dump / > ./dconf/gnome-settings.ini
	cat ./dconf/new-settings.ini >> ./dconf/gnome-settings.ini
	addRussianLayout
	dconf load / < ./dconf/gnome-settings.ini
	rm ./dconf/gnome-settings.ini
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
	enableSnapd
	sudo snap install code --classic
	pamac build google-chrome
	sudo snap install sublime-text --classic
}

function finish
{
	if ! command -v neofetch &> /dev/null
	then
    	echo "<the_command> could not be found"
	fi
	neofetch
	echo -e "$(tput setaf 2)\nFinished!\n$(tput sgr0)"
	exit
}

function askForInstall
{
	echo -e "\n"
	read -p "Install default packages? (packageList)[y/n]: " yn
	echo -e "\n"

	case $yn in 
		[yY] ) # echo -e "Installing packages...\n"
			installPackages
			finish;;
		[nN] ) 	finish;;
		* ) echo "invalid response";
			askForInstall;;
	esac
	
	finish
}

function runSetup
{
	echo -e "$(tput setaf 2)\nRunning setup...\n$(tput sgr0)"

	dowloadFont
	installFont
	makeSymbolicsLinks	
	loadGnomeSettings
	enableExtenstions
	askForInstall
	finish
}

runSetup
