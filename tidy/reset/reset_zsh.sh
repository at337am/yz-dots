#!/usr/bin/env bash

# 这个脚本会同步所有, 并且会重置 zsh, 但不会影响其它的

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset zsh?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

rm -rf ~/.zsh_history
rm -rf ~/.zcompdump
rm -rf ~/.cache/p10k*
rm -rf ~/.lain/themes

~/workspace/dev/yz-dots/bootstrap/setup/rsync_home.sh
~/workspace/dev/yz-dots/bootstrap/setup/set_p10k_theme.sh

~/workspace/dev/yz-dots/bootstrap/setup/path_perms.sh
~/workspace/dev/yz-dots/bootstrap/setup/symlinks.sh

printf "Done.\n"
