#!/bin/sh
# This script will run inside the chrooted environment
# It stops when we need to configure the kernel

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
./setup_make.conf.sh && exit 1
echo "...done."

# we use this command in the next script
emerge --verbose app-portage/cpuid2cpuflags || exit 1
./setup_local_use_flags.sh && echo "Local use flags set up." || exit 1

echo "Brazil/East" > /etc/timezone #verify this

emerge --config sys-libs/timezone-data

echo \
"en_US ISO-8859-1
en_US.UTF-8 UTF-8
pt_BR ISO-8859-1
pt_BR.UTF-8 UTF-8
" > /etc/locale.gen

locale-gen

eselect locale list | grep "en_US.UTF-8 UTF-8" | sed 's/\([0-9]\).*/\1/' | tr -d [ | tr -d ' ' | xargs eselect locale set

eselect locale list && sleep 5 # let the user see the selected locale

#this might be set later on...
#echo 'keymap="br-abnt2"' > /etc/conf.d/keymaps && echo "Set keymap"

env-update && . /etc/profile && export PS1="(chroot) ${PS1}"

emerge --verbose sys-kernel/gentoo-sources app-arch/lz4

eselect kernel set 1
eselect kernel list && sleep 5


cd /usr/src/linux || exit 1
echo "Run 'make menuconfig' in order to start configuring the kernel"
