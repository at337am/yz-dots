# ---------------- 流程 START ----------------

## 准备工作:
- pkgs/ssh.tar
- pkgs/PFP.tar
- pkgs/fonts.tar.gz
- pkgs/nekoray.tar.gz
- yz-dots.tar.gz
- config_baks_for_linux.tar


## 开始安装:

安装完 fedroa 系统后 (插网线或者连接 wifi )

先设置 dnf 代理: sudo vim /etc/dnf/dnf.conf, 或者执行脚本 gui/01_dnf_proxy.sh

更新全部软件包 sudo dnf -y upgrade

重启电脑

使用 scp -r 上传 所有所需文件到 ~/ 目录下

就地解压 yz-dots, 然后执行 bootstrap.sh <代理地址>

执行完成后都正常的话就可以重启进入 GUI 了




# ---------------- 开发 todo ----------------





# ---------------- 启动 GUI 后 todo ----------------
启动 nekoray

手动按顺序执行 yz-dots/bootstrap/gui 中的脚本

设定输入法 fcitx5-configtool

完成 config_baks_for_linux.tar 中的配置
