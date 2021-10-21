#!/bin/sh
# This is to be used exclusively within the live usb
# It assumes that:
#	1 - you have internet connection
# 	2 - your partition is set up AND mounted
# In other words, this script will work for things after the 
# "preparing the disks" part of gentoo's handbook
# It will also only run up until the 'chroot' part (the middle of
# "installing base system" in gentoo's handbook)

date
while true; do
echo "Is the date correct(UTC time)?[y/n]"
	read  -r answer
	case $answer in
		[yY]*)
			break
			;;
		[nN]*)
			echo "Fix the date and run this script again."
			exit 1
			;;
		*)
			echo "Don't be a bitch; type either 'y' or 'n'."
			;;
	esac
done

wget https://bouncer.gentoo.org/fetch/root/all/releases/amd64/autobuilds/20211018T200943Z/stage3-amd64-openrc-20211018T200943Z.tar.xz

tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

echo \
'You will now configure the basics of make.conf.
What you need to do is set common_flags to "-march=skylake -O2 -pipe"
Make sure that CFLAGS and CXXFLAGS are also set to common_flags
Finally, if MAKEOPTS exists, set it to "-j12"

Press anything to continue'
read -r
nano -w /mnt/gentoo/etc/portage/make.conf

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf
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

chroot /mnt/gentoo /bin/bash ./inside_chroot.sh && cd && \
	umount -v -l /mnt/gentoo/dev/shm && umount -v -l /mnt/gentoo/dev/pts && \
	umount -v -R /mnt/gentoo && reboot \
	|| echo "Something went wrong, you will have to continue manually.
	Begin by running 'chroot /mnt/gentoo /bin/bash'"
