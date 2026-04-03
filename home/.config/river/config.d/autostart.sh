#!/usr/bin/env bash

# 先杀死旧的进程
pkill -x "kanshi"       || true
pkill -x "mako"         || true
pkill -x "swayidle"     || true
pkill -x "waybar"       || true
pkill -x "awww-daemon"  || true
pkill -x "wob"          || true

riverctl spawn "systemctl --user import-environment DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
riverctl spawn "dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

# 显示器设置
riverctl spawn "kanshi"

# 启动布局管理器
# 2 8 / 3 7
riverctl spawn "rivertile -view-padding 3 -outer-padding 7 -main-ratio 0.5"

# 壁纸放在在显示器启动后执行
riverctl spawn "awww-daemon"
riverctl spawn "waybar"

riverctl spawn "env LANG=zh_CN.UTF-8 nm-applet --indicator"
riverctl spawn "foot --server"
riverctl spawn "mako"
riverctl spawn "env LANG=zh_CN.UTF-8 fcitx5 -d --replace"
riverctl spawn "wl-paste --type text --watch cliphist store"
riverctl spawn "wl-paste --type image --watch cliphist store"
# riverctl spawn "wl-clip-persist --clipboard regular"
riverctl spawn "/usr/bin/lxqt-policykit-agent"
riverctl spawn "thunar --daemon"

# 自动熄屏和锁屏
riverctl spawn "swayidle -w"

# 最后执行一些脚本
(
    sleep 5
    "$WM_SCRIPTS/auto/gsettings.sh"
) &

# 启动 wob 进程
# 如果管道不存在, 先尝试删除同名文件 (防止被占), 再创建管道文件
if [[ ! -p "$WOB_SOCK" ]]; then
    rm -f "$WOB_SOCK"
    mkfifo "$WOB_SOCK"
fi
riverctl spawn "sh -c 'tail -f $WOB_SOCK | wob'"
