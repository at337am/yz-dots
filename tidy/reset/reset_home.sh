#!/usr/bin/env bash

# 这个脚本会同步所有, 不会发生任何变化

set -euo pipefail

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

if ! confirm "Are you sure you want to reset home?"; then
    printf "Operation cancelled. Exiting...\n"
    exit 1
fi

/workspace/dev/yz-dots/bootstrap/setup/rsync_home.sh
rm -rf ~/.lain/themes/powerlevel10k.tar.gz

/workspace/dev/yz-dots/bootstrap/setup/path_perms.sh
/workspace/dev/yz-dots/bootstrap/setup/configure_symlinks.sh

printf "Done.\n"
