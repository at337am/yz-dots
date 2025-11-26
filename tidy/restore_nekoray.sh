#!/usr/bin/env bash

bak_path="/data/misc/restore/nekoray.tar.gz"
old_bak_path="/data/misc/restore/old/nekoray_bak_$(date +"%y%m%d_%H%M%S").tar.gz"

pkill -15 nekoray || true
sleep 1.5

restore() {
	if [[ ! -f "$bak_path" ]]; then
		printf "Error: Backup file does not exist: %s\n" "$bak_path" >&2
		exit 1
	fi

	rm -rf /opt/soft/nekoray

	tar -zxf "$bak_path" -C /opt/soft/

	printf "nekoray restored to original config\n"
}

bak() {
	mkdir -p /data/misc/restore/old/

	if [[ -f "$bak_path" ]]; then
		mv -v "$bak_path" "$old_bak_path"
	fi

	tar -zcf "$bak_path" -C /opt/soft/ nekoray

	printf "nekoray backup completed\n"
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
