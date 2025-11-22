#!/usr/bin/env bash

set -euo pipefail

# 安装完软件包后执行此脚本
# 这些都是是一次性配置脚本, 一般只需要执行一次就行了, 没必要重复利用

# todo 这里开头要检查每个命令的依赖

# 设置 sudo 过期时间为 60 分钟
echo 'Defaults    timestamp_timeout=60' | sudo tee -a /etc/sudoers
echo 'Defaults    !tty_tickets' | sudo tee -a /etc/sudoers


# 设置免密关机
echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/sbin/shutdown" | sudo tee -a /etc/sudoers



# 创建相关目录结构
mkdir -p ~/.config
mkdir -p ~/.local/share
mkdir -p ~/Pictures

sudo mkdir -p /workspace/dev /workspace/tmp
sudo chown -R $(whoami):$(id -gn) /workspace
ln -s /workspace ~/workspace

sudo mkdir -p /data/bak /data/hello /data/misc/restore /data/misc/tgboom
sudo chown -R $(whoami):$(id -gn) /data

sudo mkdir -p /opt/soft /opt/venvs
sudo chown -R $(whoami):$(id -gn) /opt/soft /opt/venvs

echo "Basic setup complete."



go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct

# 启动服务:
systemctl --user enable --now pipewire pipewire-pulse wireplumber

# 关闭文件管理器的 "最近打开"
gsettings set org.gnome.desktop.privacy remember-recent-files false
rm -f ~/.local/share/recently-used.xbel
