#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

ACCEPT_KEYWORDS_DIR=/etc/portage/package.accept_keywords
[ -f "$ACCEPT_KEYWORDS_DIR" ] && rm --verbose "$ACCEPT_KEYWORDS_DIR"
[ ! -d "$ACCEPT_KEYWORDS_DIR" ] && mkdir "$ACCEPT_KEYWORDS_DIR"

echo "app-editors/neovim ~amd64" > "$ACCEPT_KEYWORDS_DIR"/neovim
echo "app-misc/nnn ~amd64" > "$ACCEPT_KEYWORDS_DIR"/nnn
echo "dev-lang/ghc ~amd64" > "$ACCEPT_KEYWORDS_DIR"/ghc
echo "dev-lang/rust ~amd64" > "$ACCEPT_KEYWORDS_DIR"/rust
echo "dev-libs/bemenu ~amd64" > "$ACCEPT_KEYWORDS_DIR"/bemenu
echo "dev-lisp/sbcl ~amd64" > "$ACCEPT_KEYWORDS_DIR"/sbcl
echo "dev-haskell/cabal ~amd64" > "$ACCEPT_KEYWORDS_DIR"/cabal
echo "dev-util/ccls ~amd64" > "$ACCEPT_KEYWORDS_DIR"/ccls
echo "media-gfx/imv ~amd64"  > "$ACCEPT_KEYWORDS_DIR"/imv
