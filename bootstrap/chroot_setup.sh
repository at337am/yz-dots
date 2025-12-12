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
    grub \
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

# --------------------------

# 将 GRUB 安装到硬盘的 ESP 分区上
# 这一步会生成一个文件 /boot/EFI/Arch/grubx64.efi
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch

# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager.service sshd.service

printf "Done.\n"
