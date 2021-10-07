#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

LOCAL_USE_DIR=/etc/portage/package.use
[ ! -d "$LOCAL_USE_DIR" ] && mkdir -pv "$LOCAL_USE_DIR"

echo "media-sound/pulseaudio -alsa-plugin" > "$LOCAL_USE_DIR"/pulseaudio
echo "app-admin/doas persist" > "$LOCAL_USE_DIR"/doas
echo "media-video/pipewire pipewire-alsa pulseaudio" > "$LOCAL_USE_DIR"/pipewire
echo "media-video/ffmpeg sndio" > "$LOCAL_USE_DIR"/ffmpeg
echo "media-video/mpv -xv" > "$LOCAL_USE_DIR"/mpv
