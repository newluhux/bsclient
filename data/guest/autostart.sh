#!/bin/sh

POS=$(dirname $(realpath $0))

# 环境变量
export LANG=zh_CN.utf8
export LC_ALL=zh_CN.utf8

# no blank screen
xset s noblank
xset -dpms

# Input Method
export XMODIFIERS=@im=fcitx
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
fcitx-autostart

# background
xsetroot -solid black

# 代理服务器
# export http_proxy=http://xxxx:8080/
# export https_proxy=$http_proxy

# 中心控制的话请在远端302跳转或其他技术跳转
# URL=http://xxxxx/forward/

URL=file://$POS/html/index.html

# 浏览器

WEB_BROWSER_CMD0="surf"
WEB_BROWSER_CMD1="chromium"

# 浏览器循环
while true
do
	$WEB_BROWSER_CMD0 $URL
	if [ $? == 0 ]
	then
		continue
	else
		$WEB_BROWSER_CMD1 $URL
	fi
done &


# 止步于此
while true
do
	sleep 86400
done
