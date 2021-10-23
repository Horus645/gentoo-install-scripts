#!/bin/sh
# We will be printing some '\' literals, so let's disable this warning
#shellcheck disable=SC1004

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit


CONF_FILE=/etc/portage/make.conf

# Bellow, we always make sure to only set the option if it wasn't already set

sed -i 's/COMMON_FLAGS.*/COMMON_FLAGS="-march=skylake -O2 -pipe"/' $CONF_FILE \
	&& echo "Set COMMON_FLAGS" || nano -w $CONF_FILE

grep -q "MAKEOPTS" "$CONF_FILE" || echo 'MAKEOPTS="-j12"' >> "$CONF_FILE" && \
	echo "Set MAKEOPTS" || nano -w $CONF_FILE

#vaapi -- ?
grep -q "USE" "$CONF_FILE" || \
	echo \
'USE="alsa curl dbus elogind fmmpeg gtk magic opengl pulseaudio \
qt5 threads vim-syntax vaapi vdpau vulkan X xwayland wayland \
-bluetooth -cdda -cdr -css -cuda -dvd -dvdr -emacs -gnome -jack -kde \
-networkmanager -nvidia -systemd -telemetry -wifi"' >> "$CONF_FILE" && echo "Set USEFLAGS"

grep -q "ACCEPT_LICENSE" "$CONF_FILE" || \
	echo 'ACCEPT_LICENSE="-* @BINARY-REDISTRIBUTABLE"'  >> "$CONF_FILE" && \
	echo "Set license"

grep -q "GRUB_PLATFORMS" "$CONF_FILE" || echo 'GRUB_PLATFORMS="efi-64"' >> "$CONF_FILE" \
	&& echo "Set GRUB_PLATFORMS"

grep -q "EMERGE_DEFAULT_OPTS" "$CONF_FILE" || \
	echo 'MERGE_DEFAULT_OPTS="--ask --verbose --tree"' >> "$CONF_FILE" && \
	echo "Set EMERGE_DEFAULT_OPTS"

grep -q "PORTDIR_OVERLAY" "$CONF_FILE" || \
	echo \
'#PORTDIR_OVERLAY is where local ebuils may be stored without
concern that will be deleted by updates. Default is not defined.
PORTDIR_OVERLAY=/usr/local/portage' >> "$CONF_FILE" && echo "Set PORTDIR_OVERLAY"

grep -q "VIDEO_CARDS" "$CONF_FILE" || echo 'VIDEO_CARDS="-* amdgpu radeonsi"' >> "$CONF_FILE" && \
	echo "Set VIDEO_CARDS"
