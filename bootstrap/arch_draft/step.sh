#!/usr/bin/env bash

# arch 安装指南: https://wiki.archlinuxcn.org/wiki/安装指南
# pacman 官方存储库: https://archlinux.org/packages

# 放大显示字体, 恢复直接运行 setfont
setfont ter-132b

# 连接网络
# https://wiki.archlinuxcn.org/wiki/Iwd#iwctl
iwctl

# 确保一下时间是正确的
timedatectl

# 建立硬盘分区
fdisk -l
cfdisk /dev/nvme0n1
# 选择一个空闲的分区, 进行以下操作:
# New 新建一个 1G 的分区, 比如 /dev/nvme0n1p7, 然后把 type 改为 EFI
# 再选择剩下的分区, 比如 /dev/nvme0n1p8, 然后把 type 改为 filesystem
# 选择 write 写入, 输入 yes 确定
# 最后 quite 退出

# 格式化 EFI 分区
mkfs.fat -F 32 /dev/nvme0n1/p7

# 格式化 根分区
mkfs.ext4 /dev/nvme0n1/p8

# 挂载根分区
mount /dev/nvme0n1/p8 /mnt

# 挂载 EFI 分区
mkdir /mnt/boot
mount /dev/nvme0n1/p7 /mnt/boot

# 再次查看一下
fdisk -l

# ------------------ 开始安装系统 ------------------

# 设置代理
export http_proxy='http://192.168.9.104:1082'
export https_proxy='http://192.168.9.104:1082'

# 检查是否代理成功 (返回 200)
curl -I https://www.google.com


# 安装必需的软件包
pacstrap -K /mnt base linux linux-firmware
# mesa vulkan-intel intel-media-driver man-db man-pages texinfo ??


# ------------------ 配置系统 ------------------
# 生成 fstab 文件
genfstab -U /mnt > /mnt/etc/fstab

# 进入挂载的系统环境
arch-chroot /mnt

# 设置时区
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# 同步当前的系统时间到硬件时钟
hwclock --systohc

# 安装一下 nvim
pacman -S neovim

# 生成 Locale

nvim /etc/locale.gen
# 编辑文件, 取消以下两个注释:
# en_US.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8

# 执行生成命令
locale-gen

# 设置系统默认语言
nvim /etc/locale.conf
# 在创建 /etc/locale.conf 文件时，只写入英文设置:
# LANG=en_US.UTF-8

# 设置 hostname
nvim /etc/hostname


# 为 root 用户设置密码, 直接执行:
passwd

# 创建用户, 设置密码:
useradd -m -G wheel -s /bin/bash yz
passwd yz

# 设置用户 sudo 权限:
pacman -S sudo
visudo
# 取消注释:
# %wheel ALL=(ALL:ALL) ALL



# 安装引导程序 GRUB
pacman -S grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg




# 安装驱动和微码
pacman -S intel-ucode mesa vulkan-intel intel-media-driver
# 重新生成 GRUB 配置 (为了让 intel-ucode 生效)
grub-mkconfig -o /boot/grub/grub.cfg


# 安装 NetworkManager 和 SSH
pacman -S networkmanager openssh
# 启动服务
systemctl enable --now NetworkManager.service
systemctl enable --now sshd.service


# 退出 chroot, 按下 ctrl + D, 最后重启
reboot



# ------------------ 之后 ------------------

# nmcli 连接网络
# 设置代理

# 执行脚本: pacman_install.sh

chsh -s /usr/bin/zsh

# 配置自动启动 hyprland
sudo -E pacman -S uwsm

# nvim ~/.zprofile:
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
