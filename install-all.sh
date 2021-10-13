#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

./setup-make.conf.sh

emerge --verbose dev-vcs/git # after the next script we will be emerging with git

./setup-portage-repos.sh

emerge --verbose app-portage/cpuid2cpuflags # we use this command in the next script
./setup-local-use-flags.sh

tr '\n' ' ' < ./essential_packages || xargs emerge -avt 

eselect sh set dash && echo "Shell changed to dash!" # set our shell as dash
eselect sh list
sleep 5 # let the user see we've changed it

grub-mkconfig -o /boot/grub/grub.cfg # rebuild grub to load microcode

./setup-doas.sh
./setup-bleeing-edge-packages.sh

useradd -m -G users,wheel,audio,video,games,usb -s /bin/bash horus && echo "Added user horus"
passwd horus

rm --verbose /stage3-*.tar.*

echo "You may now install the packages in packages_to_install. Beware, it may take a while."