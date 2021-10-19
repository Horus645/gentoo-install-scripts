#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

LOCAL_USE_DIR=/etc/portage/package.use
[ ! -d "$LOCAL_USE_DIR" ] && mkdir -pv "$LOCAL_USE_DIR"

echo "*/* $(cpuid2cpuflags)" > "$LOCAL_USE_DIR"/00cpu-flags
echo "app-admin/doas persist" > "$LOCAL_USE_DIR"/doas
echo "app-admin/eselect doc" > "$LOCAL_USE_DIR"/eselect
echo "app-office/libreoffice cups -googledrive" > "$LOCAL_USE_DIR"/libreoffice
echo "app-shells/zsh doc gdbm unicode" > "$LOCAL_USE_DIR"/zsh
echo "dev-lang/rust nightly rls system-llvm verify-sig -clippy -miri -parallel-compiler -rustfmt -wasm" > "$LOCAL_USE_DIR"/rust
echo "dev-libs/bemenu -X" > "$LOCAL_USE_DIR"/bemenu
echo "gui-apps/mako icons" > "$LOCAL_USE_DIR"/mako
echo "gui-apps/yambar wayland -X" > "$LOCAL_USE_DIR"/yambar
echo "media-libs/mesa d3d9 gallium" > "$LOCAL_USE_DIR"/mesa
echo "media-gfx/imv freeimage heif gif jpeg png svg tiff -X" > "$LOCAL_USE_DIR"/imv
echo "media-sound/musescore -webengine" > "$LOCAL_USE_DIR"/musescore
echo "media-sound/pulseaudio -alsa-plugin" > "$LOCAL_USE_DIR"/pulseaudio
echo "media-video/ffmpeg sndio chromium" > "$LOCAL_USE_DIR"/ffmpeg
echo "media-video/mpv -xv -cuda" > "$LOCAL_USE_DIR"/mpv
echo "media-video/pipewire pipewire-alsa echo-cancel" > "$LOCAL_USE_DIR"/pipewire
echo "net-libs/nodejs npm" > "$LOCAL_USE_DIR"/nodejs
echo "sys-firmware/intel-microcode hostonly initramfs split-ucode" > "$LOCAL_USE_DIR"/intel-microcode
echo "sys-kernel/linux-firmware initramfs redistributable" > "$LOCAL_USE_DIR"/linux-firmware
echo "sys-process/bottom -battery" > "$LOCAL_USE_DIR"/bottom
