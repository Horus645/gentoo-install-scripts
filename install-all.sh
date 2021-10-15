#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

./setup-make.conf.sh

emerge --verbose dev-vcs/git # after the next script we will be emerging with git

./setup-portage-repos.sh

emerge --verbose app-portage/cpuid2cpuflags # we use this command in the next script
./setup-local-use-flags.sh

tr '\n' ' ' < essential_packages || xargs emerge -avt 

eselect sh set dash && echo "Shell changed to dash!" # set our shell as dash
eselect sh list
sleep 5 # let the user see we've changed it

grub-mkconfig -o /boot/grub/grub.cfg # rebuild grub to load microcode

./setup-doas.sh
./setup-bleeing-edge-packages.sh

useradd -m -G users,wheel,audio,video,games,usb -s /bin/bash horus && echo "Added user horus"
passwd horus

rm --verbose /stage3-*.tar.*

emerge --verbose app-misc/neofetch

neofetch && echo "WE ARE IN BOOOOOOOOIS!"

sleep 5 # let user catch their breath

while true; do
	echo "Would you like to install the packages from Gentoo's default repository now?[y/n]"
	read  -r answer
	case $answer in
		[yY]*)
			./install_general_packages.sh
			break
			;;
		[nN]*)
			echo "You may install the packages at a later date by running './install_general_packages.sh'"
			echo "Exiting..."
			break
			;;
		*)
			echo "Don't be a bitch; type either 'y' or 'n'."
			;;
	esac

done

while true; do
	echo "Would you like to install the packages from Gentoo's overlays?[y/n]"
	read  -r answer
	case $answer in
		[yY]*)
			./install_packages_from_overlays.sh
			break
			;;
		[nN]*)
			echo "You may install the packages at a later date by running './install_packages_from_overlays.sh'"
			echo "Exiting..."
			break
			;;
		*)
			echo "Don't be a bitch; type either 'y' or 'n'."
			;;
	esac

done
