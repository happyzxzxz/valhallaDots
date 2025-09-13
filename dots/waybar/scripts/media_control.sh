#!/bin/bash

CACHE_FILE="$HOME/.cache/waybar-current-player"

if [[ -f "$CACHE_FILE" ]]; then
    PLAYER=$(cat "$CACHE_FILE")
else
    # fallback если файла нет
    PLAYER=$(playerctl -l | head -n 1)
fi

case "$1" in
    play-pause) playerctl -p "$PLAYER" play-pause ;;
    next)       playerctl -p "$PLAYER" next ;;
    previous)   playerctl -p "$PLAYER" previous ;;
esac
