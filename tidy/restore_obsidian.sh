#!/usr/bin/env bash

bak_path="/data/misc/restore/obsidian_config.tar.gz"
old_bak_path="/data/misc/restore/old/obsidian_config_bak_$(date +"%y%m%d_%H%M%S").tar.gz"

restore() {
	if [[ ! -f "$bak_path" ]]; then
		printf "Error: Backup file does not exist: %s\n" "$bak_path" >&2
		exit 1
	fi

	rm -rf ~/Documents/notes/.obsidian

	tar -zxf "$bak_path" -C ~/Documents/notes/

	printf "Obsidian restored to original config\n"
}

# obsidian config 备份流程:
# 先恢复跟踪 -> 使用脚本重置 -> 改配置 -> git 提交 -> 运行此备份脚本 -> 最后忽略跟踪
bak() {
	mkdir -p /data/misc/restore/old/

	if [[ -f "$bak_path" ]]; then
		mv -v "$bak_path" "$old_bak_path"
	fi

	tar -zcf "$bak_path" -C ~/Documents/notes/ .obsidian

	printf "Obsidian backup completed\n"
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
