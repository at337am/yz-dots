#!/usr/bin/env bash

exit 0

# 测试 执行脚本
./bootstrap.sh "http://192.168.9.130:2081" 2>&1 | tee ~/output.log


# ------------ 修改 xdg-user-dirs-update 语言 START ------------

LANG=en_US.UTF-8 xdg-user-dirs-update --force

cat ~/.config/user-dirs.dirs

command rm -rfv ~/Templates ~/Public ~/Desktop

# 不需要: ~/Desktop, ~/Public, ~/Templates

# ------------ 修改 xdg-user-dirs-update 语言 END ------------






# ---------------- 流程 START ----------------

# ## 注意事项: 安装完后检查是否误装 ffmpeg-free


## 准备工作:
# pkgs/ssh.tar
# pkgs/fonts.tar.gz
# pkgs/nekoray.tar.gz

# yz-dots.tar.gz
# config_baks_for_linux.tar


## 开始安装:

# 安装完 fedroa 系统后 (插网线或者连接 wifi )

# 先设置代理环境

# 更新全部软件包 sudo dnf -y upgrade

# 重启电脑

# 再次设置代理环境

# 使用 scp -r 上传 所有所需文件到 ~/ 目录下

# 就地解压 yz-dots, 然后执行 bootstrap.sh <代理地址>

# 执行完成后都正常的话就可以重启进入 GUI 了

# 启动 nekoray

# 手动按顺序执行 tasks/gui 中的脚本

# 脚本执行完成后, 启动 GUI

# ---------------- 流程 END ----------------





# ------------- 开发 todo -------------

# 定义可以重复执行的脚本, 实现 zsh, fcitx5 重置




# ------------- 启动 GUI 后 todo -------------
fcitx5-configtool 设定输入法

完成 config_baks_for_linux.tar 中的配置
