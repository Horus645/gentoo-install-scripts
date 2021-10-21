#!/bin/sh
# This script will run inside the chrooted environment

. /etc/profile
export PS1="(chroot) ${PS1}"

mount -v /dev/sdb2 /boot

emerge-webrsync

eselect profile list | grep 'default/linux/amd64' | grep "desktop$" | sed 's/\([0-9]\).*/\1/' | tr -d [ | tr -d ' ' | xargs eselect profile set

eselect profile list | grep -F '*' | grep 'default/linux/amd64' | grep -q "desktop$" || (echo "Couldn't set profile correctly" && exit 1)

eselect profile list && sleep 5 # let the user see all is well

emerge --verbose --update --deep --newuse @world

echo "Setting up /etc/portage/make.conf..."
#this is AFTER the previous command because that one is meant to update according to our profile
./setup_make.conf.sh || exit 1
echo "...done."

# we use this command in the next script
emerge --verbose app-portage/cpuid2cpuflags || exit 1
./setup_local_use_flags.sh && echo "Local use flags set up." || exit 1

echo "Brazil/East" > /etc/timezone && emerge --config sys-libs/timezone-data

echo \
"en_US ISO-8859-1
en_US.UTF-8 UTF-8
pt_BR ISO-8859-1
pt_BR.UTF-8 UTF-8
" > /etc/locale.gen

locale-gen

eselect locale list | grep "en_US.UTF-8 UTF-8" | sed 's/\([0-9]\).*/\1/' | tr -d [ | tr -d ' ' | xargs eselect locale set

eselect locale list && sleep 5 # let the user see the selected locale

env-update && . /etc/profile && export PS1="(chroot) ${PS1}"

emerge --verbose sys-kernel/gentoo-sources app-arch/lz4

eselect kernel set 1
eselect kernel list && sleep 5


cd /usr/src/linux || exit 1
make menuconfig

while true; do
	echo "Are you ready to compile the kernel[y/n]?"
	read  -r answer
	case $answer in
		[yY]*)
			break
			;;
		[nN]*)
			make menuconfig
			;;
		*)
			echo "Don't be a bitch; type either 'y' or 'n'."
			;;
	esac
done

make -j12 && make -j12 modules_install
make install

emerge --verbose sys-kernel/genkernel sys-kernel/linux-firmware
echo "Generating initramfs..."
genkernel --install --kernel-config=./.config initramfs || exit 1
echo "...done."

lsblk
blkid
echo "You will now edit the fstab file. Make sure to take note of the above. When ready, press enter."
read -r
nano -w /etc/fstab

echo "Type in the desired hostname:"
read -r TYPED_HOSTNAME
echo \
"# Hostname fallback if /etc/hostname does not exit
hostname=\"${TYPED_HOSTNAME}\"" > /etc/conf.d/hostname && echo 'hostname set'

emerge --verbose --noreplace net-misc/netifrc
echo 'Now set config_eth0="dhcp". Press any key'
read -r
nano -w /etc/conf.d/net

cd /etc/init.d || exit 1
ln -s net.lo net.eth0
rc-update add net.eth0 default

echo "Now you will edit the hosts file"
echo "A good idea is to set it to <hostname>.homenetwork <hostname> localhost"
echo "Press enter"
read -r
nano -w /etc/hosts

echo "You will now select the keymap."
echo 'You probably want keymap="br-abnt2"'
echo "Press enter"
read -r
nano -w /etc/conf.d/keymaps

echo "Type the root password:"
passwd

echo "You will now review rc.conf. Press enter"
read -r
nano -w /etc/rc.conf

echo "Finally, you will review the hwclock. Press enter"
read -r
nano -w /etc/conf.d/hwclock


emerge --verbose app-admin/sysklogd && rc-update add sysklogd default
emerge --verbose net-misc/dhcpcd

emerge --verbose sys-process/cronie && rc-update add cronie default

emerge --verbose sys-boot/grub:2 && grub-mkconfig -o /boot/grub/grub.cfg
