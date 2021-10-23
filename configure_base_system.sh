#!/bin/sh

[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

eselect sh set dash && echo "Shell changed to dash!" || exit 1
eselect sh list || exit 1
sleep 5 # let the user see we've changed it

# rebuild grub to load microcode
echo "Rebuilding grub..."
grub-mkconfig -o /boot/grub/grub.cfg || exit 1

useradd -m -G users,wheel,audio,video,games,usb -s /bin/zsh horus && echo "Added user horus" || exit 1
passwd horus || exit 1

(echo "permit persist keepenv horus as root"
echo "permit nopass horus cmd reboot"
echo "permit nopass horus cmd poweroff") > /etc/doas.conf \
	&& echo "Doas configured!" || exit 1

rm --verbose /stage3-*.tar.* || exit 1
