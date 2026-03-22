#!/usr/bin/env bash

riverctl set-focused-tags 512

# 笔记:
# 当启动程序时, 需要使用 exec 或 & 来避免脚本变成僵尸进程
# 但是这里不可以使用 exec 来启动 firefox
# 因为启动程序后还需要执行其他操作
# 只有当 启动程序 是脚本的最后一步的时候才可以使用 exec
# 所以我这里使用 & 来实现后台运行
# 创建子进程 -> 父进程退出 -> 子进程被 systemd 收养
firefox --new-window "https://aistudio.google.com/prompts/new_chat" &

sleep 1

riverctl toggle-fullscreen

# firefox "https://gemini.google.com"
