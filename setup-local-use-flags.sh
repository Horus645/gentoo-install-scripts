#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

LOCAL_USE_DIR=/etc/portage/package.use
[ ! -d "$LOCAL_USE_DIR" ] && mkdir -pv "$LOCAL_USE_DIR"

echo "*/* $(cpuid2cpuflags)" > "$LOCAL_USE_DIR"/00cpu-flags
echo "app-admin/doas persist" > "$LOCAL_USE_DIR"/doas
echo "app-admin/eselect doc" > "$LOCAL_USE_DIR"/eselect
echo "media-video/ffmpeg sndio chromium" > "$LOCAL_USE_DIR"/ffmpeg
echo "app-office/libreoffice cups -googledrive" > "$LOCAL_USE_DIR"/libreoffice
echo "sys-kernel/linux-firmware initramfs redistributable" > "$LOCAL_USE_DIR"/linux-firmware
echo "sys-firmware/intel-microcode hostonly initramfs split-ucode" > "$LOCAL_USE_DIR"/intel-microcode
echo "media-video/mpv -xv -cuda" > "$LOCAL_USE_DIR"/mpv
echo "media-libs/mesa d3d9 gallium" > "$LOCAL_USE_DIR"/mesa
echo "media-sound/musescore -webengine" > "$LOCAL_USE_DIR"/musescore
echo "net-libs/nodejs npm" > "$LOCAL_USE_DIR"/nodejs
echo "media-video/pipewire pipewire-alsa echo-cancel" > "$LOCAL_USE_DIR"/pipewire
echo "media-sound/pulseaudio -alsa-plugin" > "$LOCAL_USE_DIR"/pulseaudio
echo "media-gfx/imv freeimage heif gif jpeg png svg tiff -X" > "$LOCAL_USE_DIR"/imv
