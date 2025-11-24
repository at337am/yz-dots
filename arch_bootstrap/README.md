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

先设置 dnf 代理: `sudo vim /etc/dnf/dnf.conf`

> 在 `[main]` 的下一行写入共享代理地址, 参考: `proxy=http://192.168.1.104:1082`

再更新全部软件包 `sudo dnf -y upgrade`

重启电脑后, 继续:

在另一台设备上使用 scp 将所有所需文件上传到 `~/` 路径下

> 参考: `scp -r FILES.TAR yz@192.168.1.101:~/`

就地解压 yz-dots, 然后执行 bootstrap.sh "<共享代理地址>"

> 参考: `./bootstrap.sh "http://192.168.1.104:1082"`

执行完成后都正常的话, 最后重启, 就可以进入 GUI 了




# ---------------- 开发 todo ----------------

- flatpak App 分为 必选 和 可选的 (在 GUI 中手动安装的)



# ---------------- 启动 GUI 后 todo ----------------
## 启动 nekoray

## 手动按顺序执行 yz-dots/bootstrap/gui 中的脚本

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
