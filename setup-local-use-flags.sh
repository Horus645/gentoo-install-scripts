#!/bin/sh

LOCAL_USE_DIR=/etc/portage/package.use/
echo "media-sound/pulseaudio -alsa-plugin" > "$LOCAL_USE_DIR"/pulseaudio
echo "app-admin/doas persist" > "$LOCAL_USE_DIR"/doas
echo "media-video/pipewire pipewire-alsa pulseaudio" > "$LOCAL_USE_DIR"/pulseaudio
echo "media-video/ffmpeg sndio" > "$LOCAL_USE_DIR"/pulseaudio
echo "media-video/mpv -xv" > "$LOCAL_USE_DIR"/pulseaudio
