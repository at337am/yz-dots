#!/usr/bin/env bash

set -euo pipefail

# 定义颜色
RED='\033[0;31m'        # 红色
NC='\033[0m'            # 重置色

restore_path="$HOME/.local/share/restore/nekoray.tar.gz"
old_restore_path="$HOME/.local/share/restore/old/nekoray_bak_$(date +"%y%m%d_%H%M%S").tar.gz"
nekoray_path="/opt/soft/nekoray"

usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -b, --bak             备份整个 nekoray\n"
    printf "  -r, --restore         重置 nekoray (默认)\n"
    printf "  -h, --help            Show this help message\n"
}

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

restore() {
	if ! confirm "Restore nekoray?"; then
    	printf "Operation cancelled.\n" >&2
	    exit 1
	fi

	if [[ ! -f "$restore_path" ]]; then
		printf "Error: %s does not exist.\n" "$restore_path" >&2
		exit 1
	fi

	pkill -15 nekoray || true
	sleep 1

	rm -rf "$nekoray_path"

	tar -zxf "$restore_path" -C /opt/soft/
}

bak() {
	if ! confirm "Back up nekoray?"; then
    	printf "Operation cancelled.\n" >&2
	    exit 1
	fi

	if [[ ! -d "$nekoray_path" ]]; then
		printf "Error: %s does not exist.\n" "$nekoray_path" >&2
		exit 1
	fi

	pkill -15 nekoray || true
	sleep 1

	mkdir -p /data/restore/old/

	if [[ -f "$restore_path" ]]; then
		mv -v "$restore_path" "$old_restore_path"
	fi

	tar -zcf "$restore_path" -C /opt/soft/ nekoray
}

# -------------- 程序主入口 --------------

# 参数个数不能大于 1
if [[ "$#" -gt 1 ]]; then
    printf "${RED}Error:${NC} Too many arguments.\n" >&2
    usage >&2
    exit 1
fi

# 如果 $1 为空 (无参数)，则赋值为 --restore
action="${1:---restore}"

case "$action" in
    -b|--bak)
		bak
        ;;
    -r|--restore)
        restore
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        printf "${RED}Error:${NC} Unknown flag %s\n" "$action" >&2
        usage >&2
        exit 1
        ;;
esac

printf "Done.\n"
