#!/bin/sh

setxkbmap -option caps:escape
[ -f "/tmp/hiddenid1" ] && rm -rf /tmp/hiddenid1
[ -f "/tmp/hiddenid2" ] && rm -rf /tmp/hiddenid2
xsetroot -cursor_name left_ptr
xrdb ~/.config/X11/.Xresources
xset r rate 300 50
exec bspwm
