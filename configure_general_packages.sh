#!/bin/sh

[ "$(id -u)" -ne 0 ] && echo "Must run as root" && exit

echo "Setting up pipewire..."
cp -vr /usr/share/pipewire/ /etc/
sed -i 's:^    #"/usr/bin/pipewire" = { args = "-c pipewire-pulse.conf" }:    "/usr/bin/pipewire" = { args = "-c pipewire-pulse.conf" }:'\
	/etc/pipewire/pipewire.conf	&& echo "Edited pipewire.conf"
pactl info | grep "Server Name" | grep "on PipeWire" && echo "Pipewire setup done!"
