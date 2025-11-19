#!/usr/bin/env bash

set -euo pipefail

cargo install cargo-cache

cargo install xh

tmp_dir=$(mktemp -d)
trap 'command rm -rf "$tmp_dir"' EXIT

git clone --depth 1 https://github.com/Linus789/wl-clip-persist "$tmp_dir/wl-clip-persist"

(
    cd "$tmp_dir/wl-clip-persist"
    cargo install --path . --force
)

printf "Done.\n"
