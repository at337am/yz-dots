#!/usr/bin/env bash

# 指定使用 rivertile 这个布局管理器
riverctl default-layout rivertile

# 边框
riverctl border-width 4
riverctl border-color-focused 0xD1D5DB59
riverctl border-color-unfocused 0xD1D5DB1A

# 设置键盘布局和选项
riverctl keyboard-layout -options "caps:escape" us

# 鼠标主题
riverctl xcursor-theme Breeze_Light 24

# 鼠标设置
riverctl input "pointer-2362-9488-PixArt_USB_Optical_Mouse" accel-profile flat
riverctl input "pointer-2362-9488-PixArt_USB_Optical_Mouse" pointer-accel -0.1
riverctl input "pointer-2362-9488-PixArt_USB_Optical_Mouse" scroll-factor 1.4

# 禁用触摸板
riverctl input "pointer-1267-12868-ELAN076D:00_04F3:3244_Touchpad" events disabled


# normal: 当鼠标移动到一个窗口上时，该窗口获得焦点。如果焦点后来被键盘操作移走了，光标在该窗口内的移动不会重新夺回焦点，除非光标先移出再移入。这是大多数用户习惯的“焦点跟随鼠标”行为。
# always: 只要鼠标在某个窗口上移动，该窗口就会强制获得焦点。这会覆盖键盘的焦点切换操作，可能会在某些情况下造成干扰。
riverctl focus-follows-cursor normal
