#!/bin/bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "Error: Invalid arguments.\n" >&2
    printf "Usage: %s <password>\n" "chroot_setup.sh" >&2
    exit 1
fi

PASSWORD="$1"

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# 同步当前的系统时间到硬件时钟
hwclock --systohc

pacman -S --needed --noconfirm \
    neovim \
    vi \
    sudo \
    efibootmgr \
    networkmanager \
    openssh \
    intel-ucode \
    mesa \
    vulkan-intel \
    intel-media-driver \
    rsync \
    terminus-font

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen

# 执行完修改后, 紧接着必须生成 locale
locale-gen

# 设置系统默认语言
# 这个目的是告诉系统, 默认使用哪一个语言
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 设置 TTY 字体
echo "FONT=ter-128b" >> /etc/vconsole.conf

# 设置 hostname
echo "ewjx" > /etc/hostname

# 创建 swap (我感觉没必要)
# fallocate -l 8G /swapfile
# chmod 600 /swapfile
# mkswap /swapfile
# echo "/swapfile none swap defaults 0 0" >> /etc/fstab

# 创建用户
useradd -m -G wheel yz

# 设置密码
echo "root:$PASSWORD" | chpasswd
echo "yz:$PASSWORD" | chpasswd

# ------------- 自定义 /etc/sudoers.d/ 中的配置 -------------
# 
# 大多数 Linux 发行版, sudo 默认会清除大部分环境变量, 包括与代理相关的变量, 
# 所以即使你在普通用户环境中设置了代理, sudo pacman 也无法使用它
# 
# 解决方法
#   方法一: 使用 sudo 的 -E 选项来继承当前用户环境变量
#   方法二: 在 /etc/sudoers 文件中允许保留特定变量

config='# Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL:ALL) ALL

# Set sudo timeout to 30 minutes
Defaults timestamp_timeout=30

# Share sudo authorization across all terminals
Defaults !tty_tickets

# Preserve proxy environment variables
Defaults env_keep += "http_proxy https_proxy no_proxy HTTP_PROXY HTTPS_PROXY NO_PROXY"
'

tmp_file=$(mktemp)
trap 'rm -rf "$tmp_file"' EXIT

echo "$config" > "$tmp_file"

if visudo -cf "$tmp_file"; then
    target_file="/etc/sudoers.d/yz_config"

    install -m 440 "$tmp_file" "$target_file"
else
    printf "Error: The generated configuration contains syntax errors.\n" >&2
    exit 1
fi

# ------------- 安装引导程序 -------------
# systemd-boot wiki: https://wiki.archlinuxcn.org/wiki/Systemd-boot
# 
# 如果是文件系统是 btrfs, 可能还需要额外处理

# 将引导程序安装到 EFI 分区 (/boot)
bootctl install

# 配置 loader.conf (全局设置)
cat <<EOF > /boot/loader/loader.conf
default arch.conf
timeout 5
console-mode max
editor no
EOF

# 获取根分区 UUID
root_uuid=$(findmnt / -n -o UUID)
if [[ -z "$root_uuid" ]]; then
    echo "Error: Missing root partition UUID"
    exit 1
fi

# 获取微码 (Intel/AMD)
microcode=""
if [[ -f "/boot/intel-ucode.img" ]]; then
    microcode="/intel-ucode.img"
elif [[ -f "/boot/amd-ucode.img" ]]; then
    microcode="/amd-ucode.img"
fi

# 创建启动条目
# systemd-boot 的设计哲学是: 一个文件对应一个启动菜单项
mkdir -p /boot/loader/entries

# 普通内核
cat <<EOF > /boot/loader/entries/arch.conf
title Arch Linux
linux /vmlinuz-linux
initrd $microcode
initrd /initramfs-linux.img
options root=UUID=$root_uuid rw
EOF

# LTS 内核
cat <<EOF > /boot/loader/entries/arch-lts.conf
title Arch Linux LTS
linux /vmlinuz-linux-lts
initrd $microcode
initrd /initramfs-linux-lts.img
options root=UUID=$root_uuid rw
EOF

# 启用自动更新 systemd-boot 服务
systemctl enable systemd-boot-update.service

echo "systemd-boot configuration complete!"

# ------------- 收尾 -------------
systemctl enable NetworkManager.service sshd.service

printf "Done.\n"
