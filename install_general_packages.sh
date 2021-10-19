#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

emerge --info | grep ^USE | grep --color=auto video_card
while true; do
	echo "Are the USE flags alright?[y/n]"
	read  -r answer
	case $answer in
		[yY]*)
			break
			;;
		[nN]*)
			echo "Fix them and rerun './install_general_packages.sh'"
			echo "Remember to also set up the configuration by running './configure_general_packages.sh'"
			echo "Exiting..."
			exit 1
			;;
		*)
			echo "Don't be a bitch; type either 'y' or 'n'."
			;;
	esac
done

tr '\n' ' ' < packages_to_install | xargs emerge --verbose --ask --tree 

echo "Note that you will be using mako (which you haven't configured yet) as the notification daemon, not dunst."
