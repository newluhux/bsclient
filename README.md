# BS Client System


# 快捷链接(浏览器测试)

https://html5test.com/

https://browserbench.org/JetStream/

https://www.baidu.com/

https://www.bing.com/


## 简述

使用GNU Guix System 生成的瘦客户端操作系统，用于访问网页。

thin.scm 为精简解决方案，面对磁盘和内存资源紧张的机器

最低要求:

```
运行内存: 512MB 以上
磁盘: 4GB 以上
```

fat.scm  为完整解决方案，暂时不开发

## 源码使用

### 准备源码

```
git clone https://github.com/newluhux/bsclient.git
```

#### 准备环境

环境要求:

```
处理器:    x86_64，支持vt-d
系统:      推荐GNU Guix System,或者安装有GNU Guix包管理器的Linux操作系统
运行内存:  4GB
```

### 构建

```
# thin
guix system build --system=x86_64-linux thin.scm
```

### 测试

```
# thin
guix system vm --system=x86_64-linux thin.scm 
```

### 生成镜像

```
# thin iso
guix system image -t iso9660 --system=x86_64-linux thin.scm 
```


### 使用镜像

#### iso镜像

生成ISO镜像之前，请在生成之前在配置文件中设置好所有内容。

#### 写入镜像

可以使用 dd 工具或 win32diskimager 写入硬盘/u盘/其他存储设备


## 运行时


### 网络

系统默认使用DHCP，建议使用DHCP。

### 维护

Ctrl + Alt + F1 进入 tty 登录 root 或 admin 账户

使用 ssh 通过IP地址访问: ssh admin@xxx.xx.xx.xx


# 参考

https://guix.gnu.org/zh-CN/manual/devel/en/html_node/Invoking-guix-time_002dmachine.html#Invoking-guix-time_002dmachine
https://guix.gnu.org/zh-CN/manual/devel/en/html_node/Invoking-guix-system.html
