# 
# arch 安装指南: https://wiki.archlinuxcn.org/wiki/安装指南
# 

exit 1



# 放大显示字体, 恢复直接运行 setfont
# setfont 命令只在当前的 Live 会话中生效
setfont ter-132b



# ------>>> 连接网络 <<<------
# 
# https://wiki.archlinuxcn.org/wiki/Iwd#iwctl

iwctl

# 列出所有 WiFi 设备:
device list

# 如果设备或其相应的适配器已关闭, 请将其打开:
# device name set-property Powered on
# adapter adapter set-property Powered on

# 开始扫描网络: (这个命令不会输出任何内容)
station <device_name> scan

# 列出所有可用的网络:
station <device_name> get-networks

# 连接到一个网络: (这里会提示输入密码)
station <device_name> connect <wifi_name>

# 连接后 ping 一下看看网络是否成功
ping ...

# 确保一下时间是正确的
timedatectl



# ------>>> 建立硬盘分区 <<<------

# 先使用 fdisk -l 查看硬盘名称, 比如是: /dev/nvme0n1
cfdisk /dev/nvme0n1
# 选择一个空闲的分区, 进行以下操作:
# New 新建一个 1G 的分区, 比如 /dev/nvme0n1p5, 然后把 type 改为 EFI
# 再选择剩下的分区, 比如 /dev/nvme0n1p6, 然后把 type 改为 filesystem
# 选择 write 写入, 输入 yes 确定
# 最后 quite 退出
# 使用 fdisk -l 查看是否成功

# 格式化 EFI 分区
mkfs.fat -F 32 /dev/nvme0n1p5

# 格式化 根分区
mkfs.ext4 /dev/nvme0n1p6

# 挂载根分区
mount /dev/nvme0n1p6 /mnt

# 挂载 EFI 分区
mkdir /mnt/boot
mount /dev/nvme0n1p5 /mnt/boot

# 再次查看一下
lsblk -pf

# 为了解决下面 pacstrap 时可能会遇到的报错, 需要提前创建这个文件, 以后可能就不需要了
mkdir /mnt/etc
echo "KEYMAP=us" > /mnt/etc/vconsole.conf



# ------>>> 开始安装系统 <<<------

# 设置代理
export http_proxy=http://192.168.9.104:1082
export https_proxy=http://192.168.9.104:1082

# 检查是否代理成功 (返回 200)
curl -I https://www.google.com

# 安装必需的软件包
pacstrap -K /mnt base linux linux-firmware



# ------>>> 配置系统 <<<------
# 生成 fstab 文件
genfstab -U /mnt > /mnt/etc/fstab

# 1. 直接把脚本下载到新系统的 root 目录下
wget -O /mnt/root/chroot_setup.sh https://你的网址/脚本.sh

# 2. 赋予执行权限
chmod +x /mnt/root/chroot_setup.sh

# 3. 执行 chroot
# 这里的路径是 /root/..., 因为对于 chroot 内部来说，/mnt 已经变成了 /
arch-chroot /mnt /root/chroot_setup.sh




# ------>>> 重启到新的系统后 <<<------

# 连接网络
nmcli connection add type wifi con-name "oishi-profile" ssid "oishi" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "110110110"

# 在另一台设备上使用 scp -r 将所需文件上传到 ~/ 下
# 所需文件:
- ssh.tar
- syncs_migration_xxx.tar
- manual_config_bak.tar

# 设置 env 代理, 可以使用下面这个命令检查是否连接成功
curl -I https://www.google.com

# 解压 syncs_migration_xxx.tar, 开始执行 bootstrap.sh

# 执行完毕后重启, 进入 GUI



# ------>>> 进入 GUI 后 <<<------

# 启动 nekoray

# 手动按顺序执行 gui 中的脚本

# 解压 manual_config_bak.tar, 完成配置

# 完成 浏览器设置
