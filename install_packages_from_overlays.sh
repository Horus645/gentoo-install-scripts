#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

#Bellow, we always make sure to only unmask the packages we need

#from the wayland overlay
eselect repository enable wayland-desktop && emaint sync --repo wayland-desktop && \
echo "gui-apps/yambar ~amd64" > /etc/portage/package.accept_keywords/wayland-desktop && \
emerge --verbose gui-apps/yambar


#from the guru overlay
eselect repository enable guru && emaint sync --repo guru && \
echo "gui-apps/foot ~amd64" > /etc/portage/package.accept_keywords/foot && \
echo "dev-util/rust-analyzer ~amd64" > /etc/portage/package.accept_keywords/rust-analyzer && \
emerge --verbose gui-apps/foot dev-util/rust-analyzer

#getting brave:
eselect repository enable brave-overlay && emaint sync --repo brave-overlay && \
emerge --verbose www-client/brave-bin

#getting hls
eselect repository enable haskell && emaint sync --repo haskell && \
echo "dev-util/haskell-language-server ~amd64" > /etc/portage/package.accept_keywords/haskell-language-server && \
emerge --verbose dev-util/haskell-language-server
