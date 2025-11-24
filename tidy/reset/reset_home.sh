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

scripts=(
    "$HOME/workspace/dev/yz-dots/bootstrap/setup/rsync_home.sh"
    "$HOME/workspace/dev/yz-dots/bootstrap/setup/path_perms.sh"
    "$HOME/workspace/dev/yz-dots/bootstrap/setup/symlinks.sh"
)

# 路径检查
for path in "${scripts[@]}"; do
    if [[ ! -f "$path" ]]; then
        printf "Error: %s does not exist.\n" "$path" >&2
        exit 1
    fi
done

# 依次执行每个脚本
for run in "${scripts[@]}"; do
    name=$(basename "$run")
    echo "-=> Running: $name"
    "$run"
    echo "-=> Completed: $name"
done

printf "Done.\n"
