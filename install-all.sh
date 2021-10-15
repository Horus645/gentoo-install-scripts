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

emerge --verbose app-misc/neofetch

neofetch && echo "WE ARE IN BOOOOOOOOIS!"

echo "You may now install the packages in packages_to_install. Beware, it may take a while."
echo "Also note that you will be using mako as the notification daemon, not dunst"
echo "VERY IMPORTANT: enable overlay guru in order to install foot as a terminal emulator"
echo "VERY IMPORTANT: enable overlay wayland-desktop in order to install yambar"

#enable the wayland overlay
eselect repository enable wayland-desktop
emaint sync --repo wayland-desktop
echo "*/*::wayland-desktop ~amd64" > /etc/portage/package.accept_keywords/wayland-desktop

#emerge --verbose gui-apps/yambar


#enable guru overlay
eselect repository enable guru
emaint sync --repo guru
echo "gui-apps/foot ~amd64" > /etc/portage/package.accept_keywords/foot

#emerge --verbose gui-apps/foot dev-util/rust-analyzer
#echo "dev-util/rust-analyzer" > /etc/portage/package.accept_keywords/rust-analyzer

#getting brave:
eselect repository enable brave-overlay
emaint sync --repo brave-overlay
emerge --verbose www-client/brave-bin

#getting hls
eselect repository enable haskell
emaint sync --repo haskell
echo "dev-util/haskell-language-server ~amd64" > /etc/portage/package.accept_keywords/haskell-language-server

emerge --verbose dev-util/haskell-language-server
