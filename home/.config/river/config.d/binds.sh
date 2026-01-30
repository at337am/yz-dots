#!/usr/bin/env bash

# Shift 的核心含义是“改变一个键的基础形态”或“执行相反/更强的操作”。
# Alt 的含义是“备用功能”或“与用户界面(UI)本身进行交互”。它的功能在不同系统中最不统一，但通常围绕这两个核心。
# Control 的核心含义是“向当前激活的应用程序发送一个控制指令(Command)”。它主要用于与软件内部的功能进行交互。

# 关闭窗口
riverctl map normal Super Q close

# 注销
riverctl map normal Alt+Control X spawn "$WM_SCRIPTS/kill_process.sh && riverctl exit"

# 锁屏
riverctl map normal Alt+Control L spawn "swaylock -f"



# ------ 启动程序 ------

riverctl map normal Super   Return  spawn "footclient"
riverctl map normal Super   E       spawn "thunar"

# 使用 Super + / 打开 AI Studio
riverctl map normal Super   slash   spawn "$WM_SCRIPTS/open_aistudio.sh"

riverctl map normal Alt     Space   spawn "$WM_SCRIPTS/dmenu/drun.sh"
riverctl map normal Super   I       spawn "$WM_SCRIPTS/dmenu/edit_config.sh"
riverctl map normal Super   V       spawn "$WM_SCRIPTS/dmenu/clipboard.sh"
riverctl map normal Super   P       spawn "$WM_SCRIPTS/dmenu/prompts.sh"



# ------ 截屏与录制 ------

riverctl map normal Shift Print             spawn "$WM_SCRIPTS/screenshot.sh area-save"
riverctl map normal Super Print             spawn "$WM_SCRIPTS/screenshot.sh full-save"
riverctl map normal Shift+Control Print     spawn "$WM_SCRIPTS/screenshot.sh area-copy"
riverctl map normal Super+Control Print     spawn "$WM_SCRIPTS/screenshot.sh full-copy"
riverctl map normal Super Scroll_Lock       spawn "$WM_SCRIPTS/recorder.sh"



# ------ 功能按键 ------

# Speakers
riverctl map normal None XF86AudioRaiseVolume   spawn "$WM_SCRIPTS/volume.sh up"
riverctl map normal None XF86AudioLowerVolume   spawn "$WM_SCRIPTS/volume.sh down"
riverctl map normal None XF86AudioMute          spawn "$WM_SCRIPTS/volume.sh mute"

# Microphone
riverctl map normal None XF86AudioMicMute       spawn "$WM_SCRIPTS/microphone.sh"

# Monitor brightness
riverctl map normal None XF86MonBrightnessUp    spawn "brightnessctl set 5%+"
riverctl map normal None XF86MonBrightnessDown  spawn "brightnessctl set 5%-"

# 屏蔽一些按键 (不执行任何操作)
riverctl map normal None Menu           spawn "/bin/true"
riverctl map normal None Insert         spawn "/bin/true"
riverctl map normal None Delete         spawn "/bin/true"
riverctl map normal None Print          spawn "/bin/true"
riverctl map normal None Scroll_Lock    spawn "/bin/true"
riverctl map normal None Pause          spawn "/bin/true"



# ------ 窗口管理 / 焦点控制 ------

# 窗口全屏
riverctl map normal Super F toggle-fullscreen

# 窗口浮动
riverctl map normal Super Z toggle-float

# Super + 鼠标左键拖动 | Super + 鼠标右键调整窗口大小
riverctl map-pointer normal Super BTN_LEFT move-view
riverctl map-pointer normal Super BTN_RIGHT resize-view

# 焦点移动
riverctl map normal Super H     focus-view left
riverctl map normal Super J     focus-view down
riverctl map normal Super K     focus-view up
riverctl map normal Super L     focus-view right

riverctl map normal Super left  focus-view left
riverctl map normal Super down  focus-view down
riverctl map normal Super up    focus-view up
riverctl map normal Super right focus-view right

# 移动窗口位置
riverctl map normal Super+Shift H       swap left
riverctl map normal Super+Shift J       swap down
riverctl map normal Super+Shift K       swap up
riverctl map normal Super+Shift L       swap right

riverctl map normal Super+Shift left    swap left
riverctl map normal Super+Shift down    swap down
riverctl map normal Super+Shift up      swap up
riverctl map normal Super+Shift right   swap right

# 调整主区域的宽度/高度
riverctl map normal Super+Alt H     send-layout-cmd rivertile "main-ratio -0.1"
riverctl map normal Super+Alt L     send-layout-cmd rivertile "main-ratio +0.1"

riverctl map normal Super+Alt left  send-layout-cmd rivertile "main-ratio -0.1"
riverctl map normal Super+Alt right send-layout-cmd rivertile "main-ratio +0.1"

# 切换主窗口的布局位置
# riverctl map normal Super+Alt H    send-layout-cmd rivertile "main-location left"
# riverctl map normal Super+Alt J    send-layout-cmd rivertile "main-location bottom"
# riverctl map normal Super+Alt K    send-layout-cmd rivertile "main-location top"
# riverctl map normal Super+Alt L    send-layout-cmd rivertile "main-location right"

# 将当前窗口提升为主窗口
# riverctl map normal Super+Shift M zoom



# ------ 标签页 ------

# 切换到上一个关注的标签集
riverctl map normal Alt Tab focus-previous-tags

for i in $(seq 1 10); do
    # 这个是左移位运算
    tag_mask=$((1 << (i - 1)))

    if [ "$i" -eq 10 ]; then
        key=0
    else
        key=$i
    fi

    # 切换到指定标签页
    riverctl map normal Super "$key" set-focused-tags "$tag_mask"

    # 将窗口移动到指定标签页
    riverctl map normal Super+Shift "$key" set-view-tags "$tag_mask"

    # 在当前标签页借看一下别的标签页中的窗口
    # riverctl map normal Super+Control "$key" toggle-focused-tags "$tag_mask"
done



# ------ 暂存区 ------

scratch_tag=$((1 << 20 ))

riverctl map normal Super S toggle-focused-tags $scratch_tag
riverctl map normal Super+Shift S set-view-tags $scratch_tag

all_but_scratch_tag=$(( ((1 << 32) - 1) ^ $scratch_tag ))
riverctl spawn-tagmask $all_but_scratch_tag
