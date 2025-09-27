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

- flatpak App 分为 必选 和 可选的 (在 GUI 中手动安装的)



# ---------------- 启动 GUI 后 todo ----------------
## 启动 nekoray

## 手动按顺序执行 yz-dots/bootstrap/gui 中的脚本

## 设定输入法

```bash
fcitx5-configtool
```

## 配置 obsidian 缩放

复制 flatpak 应用的 .desktop 文件到 ~/.local/share/applications:

```bash
cp -L ~/.local/share/flatpak/exports/share/applications/* ~/.local/share/applications
```

解决缩放问题, obsidian.desktop:

```desktop
Exec=/usr/bin/flatpak run --branch=stable --arch=x86_64 --command=obsidian.sh --file-forwarding md.obsidian.Obsidian --force-device-scale-factor=1.4 @@u %U @@
```

## 解压 config_baks_for_linux.tar, 完成配置

完成 浏览器设置
