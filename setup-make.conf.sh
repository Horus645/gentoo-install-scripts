#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit


CONF_FILE=/etc/portage/make.conf

#Bellow, we always make sure to only set the option if it wasn't already set

grep -q "MAKEOPTS" "$CONF_FILE" || printf '\nMAKEOPTS="-j12"\n\n' >> "$CONF_FILE"

#vaapi -- ?
grep -q "USE" "$CONF_FILE" || \
	echo 'USE="alsa dbus elogind fmmpeg gtk'\
	'lua_single_target_luajit pulseaudio vim-syntax vulkan X wayland'\
	'-bluetooth -cdr -cuda -dvd -emacs -gnome -kde -nvidia -jack'\
	'-lua_single_target_lua5-1 -lua_single_target_lua5-3 -lua_single_target_lua5-4'\
	'-systemd'\
	'-video_cards_nouveau -video_cards_radeon'\
	'-wifi"' >> "$CONF_FILE"

grep -q "ACCEPT_LICENSE" "$CONF_FILE" || printf '\nACCEPT_LICENSE="-* @BINARY-REDISTRIBUTABLE"\n\n'  >> "$CONF_FILE"

grep -q "GRUB_PLATFORMS" "$CONF_FILE" || echo 'GRUB_PLATFORMS="efi-64"' >> "$CONF_FILE"

grep -q "EMERGE_DEFAULT_OPTS" "$CONF_FILE" || \
	printf '\nEMERGE_DEFAULT_OPTS="--ask --verbose --tree"\n\n' >> "$CONF_FILE"

grep -q "PORTDIR_OVERLAY" "$CONF_FILE" || \
	echo \
'#PORTDIR_OVERLAY is where local ebuils may be stored without
concern that will be deleted by updates. Default is not defined.
PORTDIR_OVERLAY=/usr/local/portage' >> "$CONF_FILE"

grep -q "VIDEO_CARDS" "$CONF_FILE" || echo 'VIDEO_CARDS="amdgpu radeonsi"' >> "$CONF_FILE"
