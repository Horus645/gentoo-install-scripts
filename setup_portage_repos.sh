#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

REPOS_FILE=/etc/portage/repos.conf/gentoo.conf

if ! grep -q 'git' "$REPOS_FILE" 
then
	cp -v "$REPOS_FILE" "$REPOS_FILE".backup
	# remove the entries we got with rsync
	rm -rvf "/var/db/repos/gentoo"
	echo \
"[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
sync-type = git
sync-uri = https://github.com/gentoo-mirror/gento.git
auto-sync=yes
sync-depth = 1
sync-git-verify-commit-signature = true
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4" > "$REPOS_FILE"
fi
