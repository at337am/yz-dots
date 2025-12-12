#!/bin/bash

set -euo pipefail

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# 同步当前的系统时间到硬件时钟
hwclock --systohc

# 安装一下 nvim 和 vi 编辑器, 最好两个都要安装!
# 虽然下面直接 sed 编辑了但是最好还是用一下
pacman -S --needed neovim vi

sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen

# 执行完修改后, 紧接着必须生成 locale
locale-gen

# 设置系统默认语言
# 这个目的是告诉系统, 默认使用哪一个语言
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# 设置 hostname
echo "ewjx" > /etc/hostname

# 为 root 用户设置密码
echo "Please enter password for ROOT:"
passwd

# 创建用户, 设置密码
useradd -m -G wheel yz
echo "Please enter password for yz:"
passwd yz

# 设置用户 sudo 权限
pacman -S --needed sudo
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

# 安装引导程序 GRUB
pacman -S --needed grub efibootmgr

# 将 GRUB 安装到硬盘的 ESP 分区上
# 这一步会在 /boot/EFI 下生成一个文件 Arch/grubx64.efi
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg



# 安装驱动和微码
pacman -S --needed intel-ucode mesa vulkan-intel intel-media-driver
# 重新生成 GRUB 配置 (为了让 intel-ucode 生效)
grub-mkconfig -o /boot/grub/grub.cfg


# 安装网络服务和 ssh, 方便重启后可以连接 wifi
pacman -S --needed networkmanager openssh
# 启动服务
systemctl enable --now NetworkManager.service
systemctl enable --now sshd.service

# 提前安装 rsync, 方便后续处理
pacman -S --needed rsync

# 最后退出 chroot 环境, 重启
exit
