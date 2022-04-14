#!/bin/sh

POS=$(dirname $(realpath $0))

# no blank screen
xset s noblank
xset -dpms

# Input Method
# 为了兼容，不使用gtk_im_module和qt_im_module
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
fcitx-autostart

# background
xsetroot -solid black

# 代理服务器
# export http_proxy=http://xxxx:8080/
# export https_proxy=$http_proxy

# 中心控制的话请在远端302跳转或其他技术跳转
# URL=http://xxxxx/forward/

URL=file://$POS/index.html

# 浏览器

WEB_BROWSER_CMD="surf"

# 浏览器循环
while true
do
	$WEB_BROWSER_CMD $URL
done &


# 止步于此
while true
do
	sleep 86400
done
