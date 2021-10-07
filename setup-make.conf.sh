#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit


CONF_FILE=/etc/portage/make.conf

#Bellow, we always make sure to only set the option if it wasn't already set

grep -q "MAKEOPTS" "$CONF_FILE" && echo 'MAKEOPTS="-j12"' >> "$CONF_FILE"

#vaapi -- ?
grep -q "USE" &&
	echo 'USE="alsa dbus elogind fmmpeg gtk'\
	'lua_single_target_luajit pulseaudio X wayland'\
	'-bluetooth -cdr -cuda -dvd -emacs -gnome -nvidia'\
	'-lua_single_target_lua5-1 -lua_single_target_lua5-3 -lua_single_target_lua5-4'\
	'-systemd'\
	'-video_cards_nouveau -video_cards_radeon -video_cards_radeonsi'\
	'-wifi"' >> "$CONF_FILE"

grep -q "ACCEPT_LICENSE" "$CONF_FILE" && echo 'ACCEPT_LICENSE="-* @BINARY-REDISTRIBUTABLE"'  >> "$CONF_FILE"

grep -q "GRUB_PLATFORMS" "$CONF_FILE" && echo 'GRUB_PLATFORMS="efi-64"' >> "$CONF_FILE"

grep -q "EMEGER_DEFAULT_OPTS" "$CONF_FILE" && 
	echo 'EMERGE_DEFAULT_OPTS="--ask --verbose --tree"' >> "$CONF_FILE"

grep -q "PORTDIR_OVERLAY" "$CONF_FILE" &&
	echo '#PORTDIR_OVERLAY is where local ebuils may be stored without' &&
	echo 'concern that will be deleted by updates. Default is not defined.' &&
	echo 'PORTDIR_OVERLAY=/usr/local/portage'
