#!/usr/bin/env bash

bak_path="/data/misc/restore/nekoray.tar.gz"
old_bak_path="/data/misc/restore/old/nekoray_bak_$(date +"%y%m%d_%H%M%S").tar.gz"

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
	    printf "Operation cancelled. Exiting...\n"
	    exit 1
	fi

	pkill -15 nekoray || true
	sleep 1.5

	if [[ ! -f "$bak_path" ]]; then
		printf "Error: %s does not exist.\n" "$bak_path" >&2
		exit 1
	fi

	rm -rf /opt/soft/nekoray

	tar -zxf "$bak_path" -C /opt/soft/
}

bak() {
	if ! confirm "Are you sure you want to bak nekoray?"; then
	    printf "Operation cancelled. Exiting...\n"
	    exit 1
	fi

	if [[ ! -d "/opt/soft/nekoray" ]]; then
		printf "Error: %s does not exist.\n" "/opt/soft/nekoray" >&2
		exit 1
	fi

	pkill -15 nekoray || true
	sleep 1.5

	mkdir -p /data/misc/restore/old/

	if [[ -f "$bak_path" ]]; then
		mv -v "$bak_path" "$old_bak_path"
	fi

	tar -zcf "$bak_path" -C /opt/soft/ nekoray
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
