#!/usr/bin/env bash

# set -euo pipefail

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

rm -rf ~/.lain/themes
~/workspace/dev/yz-dots/bootstrap/setup/rsync_home.sh

~/workspace/dev/yz-dots/bootstrap/setup/path_perms.sh

~/workspace/dev/yz-dots/bootstrap/setup/symlinks.sh

printf "Done.\n"
