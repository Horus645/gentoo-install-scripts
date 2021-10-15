#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

PORTAGE_DIR=/etc/portage/package.accept_keywords
[ -f "$PORTAGE_DIR" ] && rm --verbose "$PORTAGE_DIR"
[ ! -d "$PORTAGE_DIR" ] && mkdir "$PORTAGE_DIR"

echo "app-editors/neovim amd64" > "$PORTAGE_DIR"/neovim
echo "app-misc/nnn amd64" > "$PORTAGE_DIR"/nnn
echo "dev-util/ccls amd64" > "$PORTAGE_DIR"/ccls
echo "dev-lang/ghc amd64" > "$PORTAGE_DIR"/ghc
echo "dev-lisp/sbcl amd64" > "$PORTAGE_DIR"/sbcl
echo "media-gfx/imv amd64"  > "$PORTAGE_DIR"/imv
