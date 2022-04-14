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

# 这里可以更改为中心化的url地址获取或者从页面跳转，放宽你的思路
# 例如: 
# URL=`curl http://xxxxx/get-url`
# URL=http://xxxxx/forward/

URL=file://$POS

sh $POS/surf-loop.sh $URL &
