#!/usr/bin/env bash

# 镜像地址生成器: https://archlinux.org/mirrorlist

set -euo pipefail

mirrors='#
# Arch Linux repository mirrorlist
# Generated on 2026-03-31
#

# Japan
Server = http://mirror.aria-on-the-planet.es/archlinux/$repo/os/$arch
Server = https://mirror.aria-on-the-planet.es/archlinux/$repo/os/$arch
Server = http://mirrors.cat.net/archlinux/$repo/os/$arch
Server = https://mirrors.cat.net/archlinux/$repo/os/$arch
Server = http://jp.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://jp.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
Server = http://www.miraa.jp/archlinux/$repo/os/$arch
Server = https://www.miraa.jp/archlinux/$repo/os/$arch
Server = http://mirror.rain.ne.jp/archlinux/$repo/os/$arch
Server = https://mirror.rain.ne.jp/archlinux/$repo/os/$arch
Server = http://ftp.yz.yamagata-u.ac.jp/pub/linux/archlinux/$repo/os/$arch
Server = https://ftp.yz.yamagata-u.ac.jp/pub/linux/archlinux/$repo/os/$arch
'

# 备份当前镜像列表
sudo cp -a /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo "$mirrors" | sudo tee /etc/pacman.d/mirrorlist

sudo pacman -Syyu --noconfirm

printf "Done.\n"
