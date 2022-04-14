#!/bin/sh

# no blank screen
xset s noblank
xset -dpms

# Input Method
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
fcitx-autostart

# background
xsetroot -solid black

# web browser
sh /srv/scripts/surf-loop &
