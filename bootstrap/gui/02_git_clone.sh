#!/usr/bin/env bash

set -euo pipefail

echo "Starting cloning of all projects to specified locations..."

git clone git@github.com:at337am/notes.git ~/Documents/notes

git clone git@github.com:at337am/yz-dots.git ~/workspace/dev/yz-dots

git clone git@github.com:at337am/skit.git ~/workspace/dev/skit

git clone git@github.com:at337am/raindrop.git ~/workspace/dev/raindrop

echo "Project cloning complete."
