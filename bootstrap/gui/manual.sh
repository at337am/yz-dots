# 一些需要手动执行的命令

exit 1



# ------>>> 配置 GRUB 记住你上一次的选择 <<<------

# 编辑 GRUB 的配置文件
sudo nvim /etc/default/grub

# 将默认项设置为“已保存的项”
GRUB_DEFAULT=saved
# 启用保存默认项功能
GRUB_SAVEDEFAULT=true
# 禁用子菜单
GRUB_DISABLE_SUBMENU=y

# 最后别忘了要更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg



# ------>>> 隐藏另一个分区的卷挂载 <<<------

# 先找到要隐藏分区的 UUID
lsblk
lsblk -f

# 创建 udev 规则文件
sudo nvim /etc/udev/rules.d/99-hide-partition.rules

# 在文件中粘贴以下内容
SUBSYSTEM=="block", ENV{ID_FS_UUID}=="换成你的UUID", ENV{UDISKS_IGNORE}="1"

# 重载 udev 规则
sudo udevadm control --reload-rules
sudo udevadm trigger

# 最后重启一下
