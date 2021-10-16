#!/bin/sh

# Note, if any of the commands bellow fail, we exit immediately, ALWAYS
# This is because if anything fails it could lead to an actual catastrophy

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit 1

echo "Setting up /etc/portage/make.conf..."
./setup_make.conf.sh && echo "...done." || exit 1

# after the next script we will be emerging with git, so we need to get it now
emerge --verbose dev-vcs/git || exit 1

./setup_portage_repos.sh && echo "Changed sync operation to git." || exit 1

# we use this command in the next script
emerge --verbose app-portage/cpuid2cpuflags || exit 1
./setup_local_use_flags.sh && echo "Local use flags set up." || exit 1

tr '\n' ' ' < essential_packages | xargs emerge -avt || exit 1

eselect sh set dash && echo "Shell changed to dash!" || exit 1
eselect sh list || exit 1
sleep 5 # let the user see we've changed it

# rebuild grub to load microcode
echo "Rebuilding grub..."
grub-mkconfig -o /boot/grub/grub.cfg || exit 1

./setup_bleeding_edge_packages.sh && echo "Accept keywords set." || exit 1

useradd -m -G users,wheel,audio,video,games,usb -s /bin/bash horus && echo "Added user horus" || exit 1
passwd horus || exit 1

rm --verbose /stage3-*.tar.* || exit 1

./configure-system.sh || exit 1

emerge --verbose app-misc/neofetch || exit 1
neofetch && echo "WE ARE IN BOOOOOOOOIS!" || exit 1

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
