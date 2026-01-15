#!/usr/bin/env bash

riverctl set-focused-tags 512

firefox --new-window "https://aistudio.google.com/prompts/new_chat" &

sleep 1.5

riverctl toggle-fullscreen
