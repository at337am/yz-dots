#!/usr/bin/env bash

set -euo pipefail

# git_clone() {
#     mkdir -p ~/Downloads/git_clone_tmp
#     cd ~/Downloads/git_clone_tmp
#     git clone git@github.com:at337am/notes.git
#     git clone git@github.com:at337am/yz-dots.git
#     git clone git@github.com:at337am/skit.git
#     git clone git@github.com:at337am/raindrop.git
# }

if [[ ! -d "$HOME/workspace/dev/skit" ]]; then
    printf "Error: skit directory does not exist!" >&2
    exit 1
fi

cd "$HOME/workspace/dev/skit"

just install-all

printf "Done.\n"
