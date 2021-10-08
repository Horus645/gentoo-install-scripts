#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

PORTAGE_FILE=/etc/portage/package.accept_keywords

#Note: for nnn, maybe write my own ebuild

echo \
"app-editors/neovim amd64
dev-util/ccls
dev-lisp/sbcl amd64
app-misc/nnn amd64
x11-terms/kitty
dev-lang/ghc amd64" \
>> "$PORTAGE_FILE"
