#!/usr/bin/env bash

set -euo pipefail

cargo install cargo-cache

cargo install xh

# wl-clip-persist: https://github.com/Linus789/wl-clip-persist

tmp_dir=$(mktemp -d)
trap 'command rm -rf "$tmp_dir"' EXIT

git clone --depth 1 https://github.com/Linus789/wl-clip-persist "$tmp_dir/wl-clip-persist"

(
    cd "$tmp_dir/wl-clip-persist"
    cargo build --release
)

sudo install -m 755 "$tmp_dir/wl-clip-persist/target/release/wl-clip-persist" /usr/local/bin/

printf "Done.\n"
