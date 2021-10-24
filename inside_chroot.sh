#!/bin/sh
# This script will run inside the chrooted environment
confirm_eselect_automation(){
	eselect "$1" list
	echo "Is the above ${1} correct?[y for 'yes']"
	read -r answer
	if [ ! "$answer" = 'y' ] && [ ! "$answer" = 'Y' ] && [ ! "$answer" = 'yes' ]; then
		echo "Exiting..." & sleep 1
		exit 1
	fi
}

SCRIPT_DIR=/root/install_scripts

. /etc/profile
export PS1="(chroot) ${PS1}"

mount -v /dev/sdb2 /boot

emerge-webrsync

eselect profile list | grep 'default/linux/amd64' | grep "desktop$" | sed 's/\([0-9]\).*/\1/' | tr -d [ | tr -d ' ' | xargs eselect profile set
eselect profile list | grep -F '*' | grep 'default/linux/amd64' | grep -q "desktop$" || (echo "Couldn't set profile correctly" && exit 1)
confirm_eselect_automation "profile"

emerge --verbose --update --deep --newuse @world

# we use this command in the next script
emerge --verbose app-portage/cpuid2cpuflags || exit 1
bash ${SCRIPT_DIR}/setup_local_use_flags.sh && echo "Local use flags set up." || exit 1

echo "Brazil/East" > /etc/timezone && emerge --config sys-libs/timezone-data && echo "Timezone set"

echo \
"en_US ISO-8859-1
en_US.UTF-8 UTF-8
pt_BR ISO-8859-1
pt_BR.UTF-8 UTF-8
" > /etc/locale.gen && echo "Edited locale.gen"

locale-gen && echo "Generated locales"

eselect locale list | grep "en_US.UTF-8 UTF-8" | sed 's/\([0-9]\).*/\1/' | tr -d [ | tr -d ' ' | xargs eselect locale set
confirm_eselect_automation "locale"

env-update && . /etc/profile && export PS1="(chroot) ${PS1}"

emerge --verbose sys-kernel/gentoo-sources app-arch/lz4

eselect kernel set 1
confirm_eselect_automation "kernel"

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
"${SCRIPT_DIR}"/utils/pause_with_msg.sh "You will now edit the fstab file. Make sure to take note of the above."
nano -w /etc/fstab
"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/fstab"

echo "Type in the desired hostname:"
read -r TYPED_HOSTNAME
echo \
"# Hostname fallback if /etc/hostname does not exit
hostname=\"${TYPED_HOSTNAME}\"" > /etc/conf.d/hostname
"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/conf.d/hostname"

emerge --verbose --noreplace net-misc/netifrc
"${SCRIPT_DIR}"/utils/pause_with_msg.sh 'Now set config_eth0="dhcp".'
nano -w /etc/conf.d/net
"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/conf.d/net"

cd /etc/init.d || exit 1
ln -s net.lo net.eth0
rc-update add net.eth0 default

"${SCRIPT_DIR}"/utils/pause_with_msg.sh "Now you will edit the hosts file
A good idea is to set it to <hostname>.homenetwork <hostname> localhost"
nano -w /etc/hosts
"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/hosts"

"${SCRIPT_DIR}"/utils/pause_with_msg.sh "You will now select the keymap."
nano -w /etc/conf.d/keymaps
"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/conf.d/keymaps"

echo "Type the root password:"
passwd

"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/rc.conf"

"${SCRIPT_DIR}"/utils/confirm_edit.sh "/etc/conf.d/hwclock"

emerge --verbose app-admin/sysklogd && rc-update add sysklogd default
emerge --verbose net-misc/dhcpcd

emerge --verbose sys-process/cronie && rc-update add cronie default

echo "Would you like to install grub?[y for yes]"
read -r answer
if [ ! "$answer" = 'y' ] && [ ! "$answer" = 'Y' ] && [ ! "$answer" = 'yes' ]; then
	emerge --verbose sys-boot/grub:2 && grub-mkconfig -o /boot/grub/grub.cfg
fi
