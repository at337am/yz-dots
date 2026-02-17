#!/usr/bin/env bash

set -euo pipefail

restore_path="$HOME/.local/share/restore/nekoray.tar.gz"
old_restore_path="$HOME/.local/share/restore/old/nekoray_bak_$(date +"%y%m%d_%H%M%S").tar.gz"
nekoray_path="/opt/soft/nekoray"

confirm() {
    local prompt=${1:-"Do you want to continue?"}
    read -r -p "$prompt [y/N]: " choice
    case "${choice,,}" in
        y|yes) return 0 ;;
        *) return 1 ;;
    esac
}

restore() {
	if ! confirm "Are you sure you want to restore nekoray?"; then
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
	if ! confirm "Are you sure you want to bak nekoray?"; then
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

if [[ "$#" -eq 0 ]]; then
    restore
elif [[ "$#" -eq 1 && "$1" == "bak" ]]; then
    bak
else
	printf "Error: Invalid arguments.\n" >&2
	printf "Usage: %s [bak]\n" "$(basename "$0")" >&2
    exit 1
fi

printf "Done.\n"
