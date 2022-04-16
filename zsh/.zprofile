#!/bin/zsh

# for starting X
if [ "$TTY" = "/dev/tty1" ]; then
    printf "\033[1;32mBooting into bspwm!\033[0m\n"
    exec startx ~/.config/X11/.xinitrc -- -keeptty 2> /dev/null
fi
