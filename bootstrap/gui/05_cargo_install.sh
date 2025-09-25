#!/usr/bin/env bash

set -euo pipefail

echo "Starting installation of cargo-cache..."

cargo install cargo-cache

echo "cargo-cache installed."

echo "Starting installation of xh..."

cargo install xh

echo "xh installed."
