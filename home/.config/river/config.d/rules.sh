#!/usr/bin/env bash

# 注意: 配置窗口尺寸可能会引发一些 UI 问题
# 只对 启动首页窗口 进行尺寸设置, 这样就不会影响到它的子窗口

set_small() {
    riverctl rule-add -app-id "$1" float
    riverctl rule-add -app-id "$1" -title "*" dimensions 730 570
}

set_small "xdg-desktop-portal-gtk"
set_small "localsend"
set_small "lxqt-policykit-agent"
set_small "nwg-look"
set_small "com.github.tchx84.Flatseal"
set_small "org.gnome.Nautilus"

# -----------------------

riverctl rule-add -app-id "qimgv" float
riverctl rule-add -app-id "qimgv" -title "*" dimensions 720 480

riverctl rule-add -app-id "mpv" float
# 尺寸对 mpv 不生效, 找不到解决方式, 不管了
# riverctl rule-add -app-id "mpv" -title "* - mpv" dimensions 720 480

# -----------------------

riverctl rule-add -app-id "thunar" float
riverctl rule-add -app-id "thunar" -title "* - Thunar" dimensions 730 570

riverctl rule-add -app-id "org.fcitx.fcitx5-config-qt" float
riverctl rule-add -app-id "org.fcitx.fcitx5-config-qt" -title "Fcitx *" dimensions 730 570

# -----------------------

riverctl rule-add -app-id "org.pwmt.zathura" float
riverctl rule-add -app-id "org.pwmt.zathura" -title "*" dimensions 830 630

riverctl rule-add -app-id "com.obsproject.Studio" float
riverctl rule-add -app-id "com.obsproject.Studio" -title "OBS *" dimensions 830 630

riverctl rule-add -app-id "qalculate-gtk" float
riverctl rule-add -app-id "qalculate-gtk" -title "Qalculate!" dimensions 830 630

riverctl rule-add -app-id "nekoray" float
riverctl rule-add -app-id "nekoray" -title "* NekoBox *" dimensions 830 630
riverctl rule-add -app-id "nekoray" -title "分组" dimensions 830 520
riverctl rule-add -app-id "nekoray" -title "Groups" dimensions 830 520

riverctl rule-add -app-id "org.telegram.desktop" float
riverctl rule-add -app-id "org.telegram.desktop" -title "*" dimensions 830 630
riverctl rule-add -app-id "org.telegram.desktop" -title "选择文件" dimensions 730 570
riverctl rule-add -app-id "org.telegram.desktop" -title "Choose Files" dimensions 730 570

riverctl rule-add -app-id "firefox" -title "我的足迹" float
riverctl rule-add -app-id "firefox" -title "我的足迹" dimensions 830 630



# 强制给所有窗口添加边框
riverctl rule-add -app-id "*" ssd



# -------- 绑定窗口和标签 --------
riverctl rule-add -app-id "org.telegram.desktop" tags 64
riverctl rule-add -app-id "obsidian" tags 128
