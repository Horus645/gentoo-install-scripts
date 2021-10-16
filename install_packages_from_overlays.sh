#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

ACCEPT_KEYWORDS_DIR="/etc/portage/package.accept_keywords"

# Bellow, we always make sure to only unmask the packages we need

# from the guru overlay
eselect repository enable guru && emaint sync --repo guru && \
echo "gui-apps/foot ~amd64" > "$ACCEPT_KEYWORDS_DIR"/foot && \
echo "dev-util/rust-analyzer ~amd64" > "$ACCEPT_KEYWORDS_DIR"/rust-analyzer && \
echo "gui-apps/yambar ~amd64" > "$ACCEPT_KEYWORDS_DIR"/yambar && \
emerge --verbose gui-apps/foot gui-apps/yambar dev-util/rust-analyzer

echo "You must set up yambar."

# getting brave:
eselect repository enable brave-overlay && emaint sync --repo brave-overlay && \
emerge --verbose www-client/brave-bin

# getting hls:
eselect repository enable haskell && emaint sync --repo haskell && \
echo "dev-util/haskell-language-server ~amd64" > "$ACCEPT_KEYWORDS_DIR"/haskell-language-server && \
emerge --verbose dev-util/haskell-language-server

# missing: steam
