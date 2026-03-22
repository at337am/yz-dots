#!/usr/bin/env bash

# 镜像地址生成器: https://archlinux.org/mirrorlist

set -euo pipefail

mirrors='#
# Arch Linux repository mirrorlist
# Generated on 2025-11-28
#

# Taiwan
Server = http://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
Server = https://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
Server = http://archlinux.ccns.ncku.edu.tw/archlinux/$repo/os/$arch
Server = https://archlinux.ccns.ncku.edu.tw/archlinux/$repo/os/$arch
Server = http://tw.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = https://tw.mirrors.cicku.me/archlinux/$repo/os/$arch
Server = http://free.nchc.org.tw/arch/$repo/os/$arch
Server = https://taipei.mirror.pkgbuild.com/$repo/os/$arch
Server = http://archlinux.cs.nycu.edu.tw/$repo/os/$arch
Server = https://archlinux.cs.nycu.edu.tw/$repo/os/$arch
Server = http://ftp.tku.edu.tw/Linux/ArchLinux/$repo/os/$arch
Server = http://mirror.twds.com.tw/archlinux/$repo/os/$arch
Server = https://mirror.twds.com.tw/archlinux/$repo/os/$arch

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
'

# 备份当前镜像列表
sudo cp -a /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo "$mirrors" | sudo tee /etc/pacman.d/mirrorlist

sudo pacman -Syyu --noconfirm

printf "Done.\n"
