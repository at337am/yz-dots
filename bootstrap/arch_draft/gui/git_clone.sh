#!/usr/bin/env bash

set -euo pipefail

git clone git@github.com:at337am/notes.git ~/Documents/notes

git clone git@github.com:at337am/yz-dots.git ~/workspace/dev/yz-dots

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

echo "Project cloning complete."

echo "Preparing to install skit..."

if [[ ! -d "$HOME/workspace/dev/skit" ]]; then
    echo "Error: skit directory does not exist!"
    exit 1
fi

(
    cd "$HOME/workspace/dev/skit" && \
    just install-all
)

printf "Done.\n"
