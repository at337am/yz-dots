#!/usr/bin/env bash

pkill waybar

waybar > ~/.cache/waybar.log 2>&1 &
