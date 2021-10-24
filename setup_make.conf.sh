#!/bin/sh
# We will be printing some '\' literals, so let's disable this warning
#shellcheck disable=SC1004

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

# This will make the script work inside and outside the chroot environment
if [ -d /mnt/gentoo ]; then
	CONF_FILE=/mnt/gentoo/etc/portage/make.conf
else
	CONF_FILE=/etc/portage/make.conf
fi

# Bellow, we always make sure to only set the option if it wasn't already set

if grep -q CFLAGS $CONF_FILE && grep -q CXXFLAGS $CONF_FILE && grep -q COMMON_FLAGS $CONF_FILE
then
	if sed -i 's/COMMON_FLAGS=.*/COMMON_FLAGS="-march=skylake -O2 -pipe"/' $CONF_FILE
	then
		echo "COMMON_FLAGS set"
	else
		echo "Something went wrong when editing COMMON_FLAGS. Press enter to edit make.conf"
		read -r
		nano -w $CONF_FILE
	fi
else
	echo "This make.conf file is weird. You'll have to edit manually. Press enter."
	read -r
	nano -w $CONF_FILE
fi

if ! grep -q "MAKEOPTS" "$CONF_FILE"; then
	echo 'MAKEOPTS="-j12"' >> "$CONF_FILE"
	echo "MAKEOPTS set"
else
	echo "MAKEOPTS already exits. Please review it. Press enter."
	read -r
	nano -w $CONF_FILE
fi

grep -q "USE" "$CONF_FILE" || \
	echo \
'USE="alsa curl dbus elogind fmmpeg gtk magic opengl pulseaudio \
qt5 threads vim-syntax vaapi vdpau vulkan X xwayland wayland \
-bluetooth -cdda -cdr -css -cuda -dvd -dvdr -emacs -gnome -jack -kde \
-networkmanager -nvidia -systemd -telemetry -wifi"' >> "$CONF_FILE" && echo "USEFLAGS set"

grep -q "ACCEPT_LICENSE" "$CONF_FILE" || \
	echo 'ACCEPT_LICENSE="-* @BINARY-REDISTRIBUTABLE"'  >> "$CONF_FILE" && \
	echo "License set"

grep -q "GRUB_PLATFORMS" "$CONF_FILE" || echo 'GRUB_PLATFORMS="efi-64"' >> "$CONF_FILE" \
	&& echo "GRUB_PLATFORMS set"

grep -q "EMERGE_DEFAULT_OPTS" "$CONF_FILE" || \
	echo 'EMERGE_DEFAULT_OPTS="--ask --verbose --tree"' >> "$CONF_FILE" && \
	echo "EMERGE_DEFAULT_OPTS set"

grep -q "PORTDIR_OVERLAY" "$CONF_FILE" || \
	echo \
'#PORTDIR_OVERLAY is where local ebuils may be stored without
#concern that will be deleted by updates. Default is not defined.
PORTDIR_OVERLAY=/usr/local/portage' >> "$CONF_FILE" && echo "PORTDIR_OVERLAY set"

grep -q "VIDEO_CARDS" "$CONF_FILE" || echo 'VIDEO_CARDS="amdgpu radeonsi -nvidia"' >> "$CONF_FILE" && \
	echo "VIDEO_CARDS set"
