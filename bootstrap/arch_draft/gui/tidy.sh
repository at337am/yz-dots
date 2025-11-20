#!/usr/bin/env bash

set -euo pipefail

# 关闭文件管理器的 "最近打开"
gsettings set org.gnome.desktop.privacy remember-recent-files false

rm -f ~/.local/share/recently-used.xbel
