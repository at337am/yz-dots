#!/usr/bin/env bash

set -euo pipefail

# 定义颜色
RED='\033[0;31m'        # 红色
NC='\033[0m'            # 重置色

restore_path="$HOME/.local/share/restore"
mkdir -p "$restore_path"

bak_file_path="$restore_path/nekoray.tar.gz"
old_bak_dir_path="$restore_path/old"

nekoray_path="/opt/soft/nekoray"

singbox_geoip_url="https://github.com/SagerNet/sing-geoip/releases/latest/download/geoip.db"
singbox_geosite_url="https://github.com/SagerNet/sing-geosite/releases/latest/download/geosite.db"

usage() {
    printf "Usage:\n"
    printf "  %s [flags]\n" "$(basename "$0")"
    printf "\nFlags:\n"
    printf "  -b, --bak             备份整个 NekoRay\n"
    printf "  -r, --restore         重置整个 NekoRay (默认)\n"
    printf "  -u, --update          更新 NekoRay 的 Geo Database\n"
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

stop_nekoray() {
    pkill -15 nekoray || true
    sleep 1
}

# 更新 Geo Database
update_geo_database() {
    if ! confirm "Update NekoRay's Geo Database?"; then
        printf "Operation cancelled.\n" >&2
        exit 1
    fi

    if [[ ! -d "$nekoray_path" ]]; then
        printf "Error: %s does not exist.\n" "$nekoray_path" >&2
        exit 1
    fi

    # 创建临时目录
    local tmp_dir
    tmp_dir=$(mktemp -d)
    trap 'rm -rf "$tmp_dir"' EXIT

    # 先下载到临时目录
    if ! wget -O "$tmp_dir/geoip.db" "$singbox_geoip_url"; then
        printf "${RED}Error:${NC} Failed to download GeoIP database.\n" >&2
        exit 1
    fi

    if ! wget -O "$tmp_dir/geosite.db" "$singbox_geosite_url"; then
        printf "${RED}Error:${NC} Failed to download GeoSite database.\n" >&2
        exit 1
    fi

    stop_nekoray

    printf "Applying new Geo Databases...\n"

    # 最后再进行覆盖替换
    mv -f "$tmp_dir/geoip.db" "$nekoray_path/geoip.db"
    mv -f "$tmp_dir/geosite.db" "$nekoray_path/geosite.db"
}

# 重置整个 NekoRay
restore() {
    if ! confirm "Restore NekoRay?"; then
        printf "Operation cancelled.\n" >&2
        exit 1
    fi

    if [[ ! -f "$bak_file_path" ]]; then
        printf "Error: %s does not exist.\n" "$bak_file_path" >&2
        exit 1
    fi

    stop_nekoray

    rm -rf "$nekoray_path"

    tar -zxf "$bak_file_path" -C /opt/soft/
}

# 备份整个 NekoRay
bak() {
    if ! confirm "Back up NekoRay?"; then
        printf "Operation cancelled.\n" >&2
        exit 1
    fi

    if [[ ! -d "$nekoray_path" ]]; then
        printf "Error: %s does not exist.\n" "$nekoray_path" >&2
        exit 1
    fi

    stop_nekoray

    mkdir -p "$old_bak_dir_path"

    if [[ -f "$bak_file_path" ]]; then
        mv -v "$bak_file_path" "$old_bak_dir_path/nekoray_bak_$(date +"%y%m%d_%H%M%S").tar.gz"
    fi

    tar -zcf "$bak_file_path" -C /opt/soft/ nekoray
}

# -------------- 程序主入口 --------------

# 参数个数不等于 1
if [[ "$#" -ne 1 ]]; then
    printf "${RED}Error:${NC} Exactly one argument is required.\n" >&2
    usage >&2
    exit 1
fi

action="$1"

case "$action" in
    -b|--bak)
        bak
        ;;
    -r|--restore)
        restore
        ;;
    -u|--update)
        update_geo_database
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
