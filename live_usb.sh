#!/bin/sh
# This is to be used exclusively within the live usb
# It assumes that:
#	1 - you have internet connection
# 	2 - your partition is set up AND mounted
# In other words, this script will work for things after the 
# "preparing the disks" part of gentoo's handbook
# It will also only run up until the 'chroot' part (the middle of
# "installing base system" in gentoo's handbook)

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"

while true; do
	echo \
"There are 3 things you must do before running this script:
	1 - check your internet connection;
	2 - setup your partitionning scheme
	3 - mount everything in /mnt/gentoo (and activate swap, if you have it)

	Have you done all this?[y/n]"
	read  -r answer
	case $answer in
		[yY]*) break ;;
		[nN]*) echo "Then do them." ; exit 1 ;;
		*) echo "Don't be a bitch; type either 'y' or 'n'." ;;
	esac
done

date
while true; do
	echo "Is the date correct(UTC time)?[y/n]"
	read  -r answer
	case $answer in
		[yY]*) break ;;
		[nN]*) echo "Fix the date and run this script again." ; exit 1 ;;
		*) echo "Don't be a bitch; type either 'y' or 'n'."	;;
	esac
done

cd /mnt/gentoo || (echo "/mnt/gentoo does not exist!" ; exit 1)
echo "Now in $(pwd)"
wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20211018T200943Z/stage3-amd64-openrc-20211018T200943Z.tar.xz || exit 1

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

echo "Setting up /mnt/gentoo/etc/portage/make.conf..."
"${SCRIPT_DIR}"/setup_make.conf.sh || (echo "...failed! Exiting..." ; exit 1)
"$SCRIPT_DIR"/utils/warn_and_edit.sh "/mnt/gentoo/etc/portage/make.conf" "...done."

if type "mirrorselect" > /dev/null; then
	"$SCRIPT_DIR"/utils/pause_with_msg.sh "In this next menu, you can select things by pressing <space>"
	mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
fi

mkdir -v --parents  /mnt/gentoo/etc/portage/repos.conf
cp -v /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cp -v --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount -v --types proc /proc /mnt/gentoo/proc
mount -v --rbind /sys /mnt/gentoo/sys
mount -v --make-rslave /mnt/gentoo/sys
mount -v --rbind /dev /mnt/gentoo/dev
mount -v --make-rslave /mnt/gentoo/dev
mount -v --bind /run /mnt/gentoo/run
mount -v --make-slave /mnt/gentoo/run

mkdir -vp /mnt/gentoo/root/install_scripts
cp -vr "${SCRIPT_DIR}"/* /mnt/gentoo/root/install_scripts
chroot /mnt/gentoo /bin/bash /root/install_scripts/inside_chroot.sh && cd && \
	umount -v -l /mnt/gentoo/dev/shm && umount -v -l /mnt/gentoo/dev/pts && \
	umount -v -R /mnt/gentoo && echo "You may now reboot the system" \
	|| echo "Something went wrong, you will have to continue manually.
	Begin by running 'chroot /mnt/gentoo /bin/bash'"
