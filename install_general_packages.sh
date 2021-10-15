#!/bin/sh

# Make sure we are running as root:
[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

tr '\n' ' ' < packages_to_install | xargs emerge --verbose --ask --tree 

echo "Note that you will be using mako (which you haven't configured yet) as the notification daemon, not dunst."
