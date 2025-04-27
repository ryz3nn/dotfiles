#!/bin/bash

#[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval "$(dbus-launch --sh-syntax --exit-with-session)"
fi

feh ~/dotfiles/wallpaper/vltk.jpg --bg-scale &
#VBoxClient-all &
at-spi-bus-launcher --launch-immediately &
sh -c 'IM_CONFIG_CHECK_ENV=1 im-launch true' &
picom &
lxqt-policykit-agent & 
slstatus &
#/usr/libexec/geoclue-2.0/demos/agent &
#/usr/bin/lubuntu-update &
#nm-applet &
#nm-tray &
#system-config-printer-applet &
#/usr/bin/spice-vdagent &
#blueman-applet &

# Autostart
#stretchly &
ibus start & ibus engine BambooUs &
sxhkd &

exec dwm
