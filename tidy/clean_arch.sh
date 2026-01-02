#!/usr/bin/env bash

set -euo pipefail

sudo rm -rfv /var/cache/pacman/pkg/download-*

yay -Yc --noconfirm

yay -Sc --noconfirm

printf "Done.\n"
