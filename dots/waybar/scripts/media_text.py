#!/usr/bin/env python3
import subprocess
import json
import os

DEVNULL = subprocess.DEVNULL
CACHE_FILE = os.path.expanduser("~/.cache/waybar-current-player")

def get_players():
    try:
        out = subprocess.check_output(["playerctl", "-l"], text=True, stderr=DEVNULL).strip()
        return out.splitlines() if out else []
    except subprocess.CalledProcessError:
        return []

def get_status(player):
    try:
        return subprocess.check_output(["playerctl", "-p", player, "status"], text=True, stderr=DEVNULL).strip().lower()
    except subprocess.CalledProcessError:
        return "stopped"

def get_metadata(player):
    try:
        return subprocess.check_output(["playerctl", "-p", player, "metadata", "--format", "{{title}}"], text=True, stderr=DEVNULL).strip()
    except subprocess.CalledProcessError:
        return ""

data = {}
players = get_players()

if not players:
    data["text"] = "Please, select a song"
    data["class"] = "stopped"
else:
    # прочитаем кэш (если есть)
    cached = None
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE, "r") as f:
                cached = f.read().strip()
        except Exception:
            cached = None

    chosen = None

    # 1) Если кэш валиден — используем его (и НЕ перезаписываем)
    if cached and cached in players:
        chosen = cached
    else:
        # 2) Если кэша нет или он невалидный — ищем играющий
        for p in players:
            if get_status(p) == "playing":
                chosen = p
                break
        # 3) Если нет играющих — берём первого
        if not chosen:
            chosen = players[0]
        # сохраняем в кэш, т.к. раньше валидного кэша не было
        try:
            os.makedirs(os.path.dirname(CACHE_FILE), exist_ok=True)
            with open(CACHE_FILE, "w") as f:
                f.write(chosen)
        except Exception:
            pass

    status = get_status(chosen)
    meta = get_metadata(chosen)
    data["text"] = meta if meta else "Please, select a song"
    data["class"] = status

# Обновляем арт/waybar
subprocess.run(["pkill", "-RTMIN+10", "waybar"], check=False)

print(json.dumps(data))
