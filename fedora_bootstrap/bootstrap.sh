#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -ne 1 ]]; then
    printf "Invalid arguments\n" >&2
    printf "Usage: %s <proxy_address>\n" "bootstrap.sh" >&2
    exit 1
fi

export http_proxy="$1"
export https_proxy="$1"
export HTTP_PROXY="$1"
export HTTPS_PROXY="$1"

echo "Current proxy address: $http_proxy"

log() {
    printf '\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n-=> %s\n-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n\n' "$1"
}

# ------------- Executing Scripts START -------------- #
SCRIPT_DIR="tasks"

if [[ ! -d "$SCRIPT_DIR" ]]; then
    log "Error: Directory '$SCRIPT_DIR' does not exist."
    exit 1
fi

find "$SCRIPT_DIR" -maxdepth 1 -name "*.sh" | sort -V | while read -r script; do
    log "Starting execution of script: $script"

    source "$script"

    exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log "Error: Script '$script' failed with exit code: $exit_code"
        exit 1
    fi
done
# ------------- Executing Scripts END -------------- #


# Final Step:
log "Setting zsh as default shell..."
chsh -s /usr/bin/zsh
