#!/bin/sh

# 应用环境变量
. /etc/profile

# 为root账户设置密码
root_password='toor'
echo root:$root_password | chpasswd

# 为admin账户设置密码
admin_password='toor'
echo admin:$admin_password | chpasswd
