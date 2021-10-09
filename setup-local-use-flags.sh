#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

LOCAL_USE_DIR=/etc/portage/package.use
[ ! -d "$LOCAL_USE_DIR" ] && mkdir -pv "$LOCAL_USE_DIR"

echo "app-admin/eselect doc" > "$LOCAL_USE_DIR"/eselect
echo "media-sound/pulseaudio -alsa-plugin" > "$LOCAL_USE_DIR"/pulseaudio
echo "app-admin/doas persist" > "$LOCAL_USE_DIR"/doas
echo "media-video/pipewire pipewire-alsa echo-cancel" > "$LOCAL_USE_DIR"/pipewire
echo "media-video/ffmpeg sndio chromium" > "$LOCAL_USE_DIR"/ffmpeg
echo "media-video/mpv -xv -cuda" > "$LOCAL_USE_DIR"/mpv
echo "net-libs/nodejs npm" > "$LOCAL_USE_DIR"/nodejs
echo "app-office/libreoffice cups -googledrive" > "$LOCAL_USE_DIR"/libreoffice
echo "media-sound/musescore -webengine" > "$LOCAL_USE_DIR"/musescore
echo "*/* $(cpuid2cpuflags)" > "$LOCAL_USE_DIR"/00cpu-flags
echo "sys-firmware/intel-microcode hostonly initramfs split-ucode" > "$LOCAL_USE_DIR"/intel-microcode
echo "sys-kernel/linux-firmware initramfs redistributable" > "$LOCAL_USE_DIR"/linux-firmware
