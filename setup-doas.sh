#!/bin/sh

(echo "permit persist keepenv horus as root"
echo "permit nopass horus cmd reboot"
echo "permit nopass horus cmd poweroff") >> /etc/doas.conf
