#!/usr/bin/env bash

set -euo pipefail

# todo 这里检查所需文件是否存在, 比如 ssh

setup/base.sh
setup/pacman_install.sh
setup/xdg-user-dirs.sh
setup/rsync_home.sh
setup/symlinks.sh
setup/fcitx5.sh
setup/install_themes.sh
setup/configuration.sh
setup/yay_install.sh


# finish
chsh -s /usr/bin/zsh