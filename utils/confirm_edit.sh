#!/bin/sh
[ $# -lt 1 ] && echo "Specify the file that was edited." && exit 1

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
while true; do
	cat "$1"
	echo "Is the above ${1} to your liking?[y/n]"
	read -r answer
	case $answer in
		[yY]*) break;;
		[nN]*)
			"$SCRIPT_DIR"/pause_with_msg.sh "In that case, please edit what you don't like."
			nano -w "$1"
			;;
		*) echo "Don't be a bitch; type either 'y' or 'n'.";;
	esac
done
