;; 为降低磁盘和内存占用努力
(use-modules (gnu) (guix gexp) (guix records))
(use-package-modules busybox linux)
(use-service-modules base networking ssh sddm desktop dbus shepherd linux sound)

(load "module/packages/suckless.scm")
(load "module/packages/linux.scm")

;; 开机执行脚本服务
(define-record-type* <rclocal-configuration>
  rclocal-configuration make-rclocal-configuration
  rclocal-configuration?
  (name rclocal-configuration-name
   (default "default"))
  (bootup rclocal-configuration-bootup
   (default "/etc/rc.local"))
  (shutdown rclocal-configuration-shutdown
   (default "/etc/rc.shutdown")))

(define-public rclocal-service-type
  (shepherd-service-type
   'rclocal
   (lambda (config)
    (let ((name (rclocal-configuration-name config))
     (bootup (rclocal-configuration-bootup config))
     (shutdown (rclocal-configuration-shutdown config)))

      (shepherd-service
       (documentation "run script on boot & shutdown")
       (requirement '(user-processes))
       (provision (list (symbol-append 'rclocal- (string->symbol name))))
       (start #~(lambda _ (invoke #$(file-append busybox "/bin/sh") #$bootup)))
       (stop #~ (lambda _ (invoke #$(file-append busybox "/bin/sh") #$shutdown)))
       (one-shot? #t))))
  (description "run script on boot & shutdown")))

(define thin-os
 (operating-system
  (host-name "bsclient")
  (timezone "Asia/Shanghai")
  (locale "zh_CN.utf8")
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (targets '("/dev/sda"))))
  (file-systems
   (cons*
    (file-system
     (device (file-system-label "bsclient-root"))
     (mount-point "/")
     (type "ext4"))
    %base-file-systems))
  (users
   (cons*
    (user-account
     (name "admin")
     (comment "Administrator")
     (group "users")
     (supplementary-groups
      (list "wheel" "audio" "video" "input" "dialout" "lp" "netdev")))
    (user-account
     (name "guest")
     (comment "Guest")
     (group "guest")
     (supplementary-groups
      (list "audio" "video")))
    %base-user-accounts))
   (groups
    (cons*
     (user-group
      (name "guest"))
     %base-groups))
   (packages
    (cons*
     dwm-modify ; 魔改过的窗口管理器
     surf-modify ; 魔改过的浏览器
     (map
      specification->package
      (list
       "nss-certs" ; 默认TLS证书
       "busybox" ; 系统管理工具集
       "xset" "xsetroot" "xclip" "xdotool" "scrot" "xkbset" ; 图形界面工具
       "fcitx" "fcitx-configtool" "dbus" ; 输入法
       "font-gnu-unifont" "fontconfig" ; 字体
       ;; 视频支持
       "gstreamer" "gst-plugins-good"
       "gst-plugins-base" "gst-plugins-ugly"
       "gst-plugins-bad" "gst-libav"
       "ffmpeg" "libva"

       ;; 图形加速
       "intel-vaapi-driver" "libvdpau-va-gl" "libvdpau"

       "icecat" "ungoogled-chromium" ; 备用标准浏览器
       "mpv" ; 视频播放器
       "wol" ; 网络唤醒工具
       "strace" "tcpdump" ; 调试工具
       ))))
   (services
    (list
     (pam-limits-service 
      (list
       (pam-limits-entry "@guests" 'both 'nproc 8192) ; 游客账户资源限制
       (pam-limits-entry "@guests" 'both 'core 8192))) ; 调试
     (service earlyoom-service-type ; 杀死内存占用过多触发阀值的进程
      (earlyoom-configuration
       (earlyoom earlyoom-162)
       (minimum-available-memory 10) ; 运行内存阀值
       (minimum-free-swap 10) ; 交换空间阀值
       (memory-report-interval 5)
       (prefer-regexp "(^|/)(surf|chromium|icecat)$") ; 优先杀死的进程
       (avoid-regexp "(^|/)(sshd|shepherd|mcron|Xorg|dwm|fcitx)$"))) ; 白名单，无论如何都不杀死
     (service openssh-service-type
      (openssh-configuration
       (extra-content
        "AllowGroups users"))) ; 登录白名单
     (service ntp-service-type ; ntp 网络校时
      (ntp-configuration
       (servers
        (list
         (ntp-server
          (type 'server)
          (address "ntp1.aliyun.com")
          (options `(iburst (version 3) (maxpoll 16) prefer)))
         (ntp-server
          (type 'server)
          (address "ntp2.aliyun.com")
          (options `(iburst (version 3) (maxpoll 16) prefer)))))))
     (service network-manager-service-type) ; 网络管理器
     (service wpa-supplicant-service-type)
     (service static-networking-service-type
      (list %loopback-static-networking)) ; loopback interface
     (service sddm-service-type ; 图形界面登录管理器
      (sddm-configuration
       (display-server "x11")
       (numlock "off") ; 笔记本不希望默认开机numlock
       (auto-login-user "guest") ; 自动登录
       (auto-login-session "dwm.desktop")
       (relogin? #t)))
     (syslog-service) ; 日志服务
     (service urandom-seed-service-type) ; 随机数

     ;; tty 服务(用于维护)
     (service virtual-terminal-service-type)
     (service login-service-type)
     (service mingetty-service-type
      (mingetty-configuration
       (tty "tty1")))

     ;; 一些服务的依赖
     (elogind-service)
     (dbus-service)

     ;; 硬件服务
     (service udev-service-type
      (udev-configuration
       (rules
        (list alsa-utils fuse))))
     ;; 音频服务
     (service alsa-service-type)
     (service pulseaudio-service-type)

     ;; 脚本解释器
     (service special-files-service-type
      `(("/bin/sh" ,(file-append busybox "/bin/sh"))
        ("/usr/bin/env" ,(file-append busybox "/bin/env"))))

     (service rclocal-service-type ; 开机启动脚本
      (rclocal-configuration
       (bootup "/data/boot/bootup.sh")))
     (extra-special-file ; 数据文件
      "/data"
      (local-file "./data"
       #:recursive? #t))))))

thin-os
