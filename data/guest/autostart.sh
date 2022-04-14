#!/bin/sh

POS=$(dirname $(realpath $0))

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

# 中心控制的话请在远端302跳转或其他技术跳转
# URL=http://xxxxx/forward/

URL=file://$POS/index.html

sh $POS/surf-loop.sh $URL &
