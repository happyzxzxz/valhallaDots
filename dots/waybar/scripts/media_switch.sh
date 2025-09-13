#!/bin/bash

CACHE_FILE="$HOME/.cache/waybar-current-player"

# Получаем список плееров
PLAYERS=($(playerctl -l 2>/dev/null))
if [ ${#PLAYERS[@]} -eq 0 ]; then
    exit 0
fi

# Текущий плеер
if [[ -f "$CACHE_FILE" ]]; then
    CURRENT=$(cat "$CACHE_FILE")
else
    CURRENT=""
fi

# Найти индекс текущего
NEXT=""
for i in "${!PLAYERS[@]}"; do
    if [[ "${PLAYERS[$i]}" == "$CURRENT" ]]; then
        NEXT_INDEX=$(( (i + 1) % ${#PLAYERS[@]} ))
        NEXT="${PLAYERS[$NEXT_INDEX]}"
        break
    fi
done

# Если не нашли текущего в списке — берём первого
if [[ -z "$NEXT" ]]; then
    NEXT="${PLAYERS[0]}"
fi

# Сохраняем
echo "$NEXT" > "$CACHE_FILE"

# Обновляем waybar (и арт, и текст)
pkill -RTMIN+10 waybar
