# wow ~

# arch 安装指南: https://wiki.archlinuxcn.org/wiki/安装指南

# 放大显示字体, 恢复直接运行 setfont
setfont ter-132b

# 连接网络
# https://wiki.archlinuxcn.org/wiki/Iwd#iwctl
iwctl

# 确保一下时间是正确的
timedatectl

# 建立硬盘分区
# 先使用 fdisk -l 查看硬盘名称, 比如是: /dev/nvme0n1
cfdisk /dev/nvme0n1
# 选择一个空闲的分区, 进行以下操作:
# New 新建一个 1G 的分区, 比如 /dev/nvme0n1p7, 然后把 type 改为 EFI
# 再选择剩下的分区, 比如 /dev/nvme0n1p8, 然后把 type 改为 filesystem
# 选择 write 写入, 输入 yes 确定
# 最后 quite 退出
# 使用 fdisk -l 查看是否成功

# 格式化 EFI 分区
mkfs.fat -F 32 /dev/nvme0n1p7

# 格式化 根分区
mkfs.ext4 /dev/nvme0n1p8

# 挂载根分区
mount /dev/nvme0n1p8 /mnt

# 挂载 EFI 分区
mkdir /mnt/boot
mount /dev/nvme0n1p7 /mnt/boot

# 再次查看一下
lsblk -pf

# ------------------ 开始安装系统 ------------------

# 设置代理
export http_proxy=http://192.168.9.104:1082
export https_proxy=http://192.168.9.104:1082

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

# 安装一下 nvim 和 vi 编辑器
pacman -S neovim vi

# 生成 Locale
# 这个目的是告诉系统, 需要生成哪些语言包
nvim /etc/locale.gen
# 编辑文件, 取消以下两个注释:
# en_US.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8

# 执行生成命令
locale-gen

# 设置系统默认语言
# 这个目的是告诉系统, 默认使用哪一个语言
nvim /etc/locale.conf
# 在创建 /etc/locale.conf 文件时，只写入英文设置:
# LANG=en_US.UTF-8

# 设置 hostname
nvim /etc/hostname


# 为 root 用户设置密码, 直接执行:
passwd

# 创建用户, 设置密码:
useradd -m -G wheel yz
passwd yz

# 设置用户 sudo 权限:
pacman -S sudo
visudo
# 取消注释:
# %wheel ALL=(ALL:ALL) ALL



# 安装引导程序 GRUB
pacman -S grub efibootmgr

# 将 GRUB 安装到硬盘的 ESP 分区上
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
# 生成配置文件
grub-mkconfig -o /boot/grub/grub.cfg



# 安装驱动和微码
pacman -S intel-ucode mesa vulkan-intel intel-media-driver
# 重新生成 GRUB 配置 (为了让 intel-ucode 生效)
grub-mkconfig -o /boot/grub/grub.cfg


# 安装网络服务和 ssh, 方便重启后可以连接 wifi
pacman -S networkmanager openssh
# 启动服务
systemctl enable --now NetworkManager.service
systemctl enable --now sshd.service

# 提前安装 rsync, 方便后续处理
pacman -S rsync

# 最后退出 chroot 环境, 重启
exit
reboot


# ------------------ 之后 ------------------

# nmcli 连接网络

# 使用 另一台手机 scp -r 上传所需文件

# 设置 env 代理

# 执行 脚本

# bootstrap 脚本从这里开始书写




# END:
chsh -s /usr/bin/zsh
