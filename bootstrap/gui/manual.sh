# 一些需要手动执行的命令

exit 1


# 配置 GRUB 记住你上一次的选择
sudo nvim /etc/default/grub

# 将默认项设置为“已保存的项”
GRUB_DEFAULT=saved
# 启用保存默认项功能
GRUB_SAVEDEFAULT=true
# 禁用子菜单
GRUB_DISABLE_SUBMENU=y

# 最后别忘了要更新引导程序
sudo grub-mkconfig -o /boot/grub/grub.cfg
