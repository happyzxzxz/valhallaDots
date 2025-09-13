#!/usr/bin/env python3
import subprocess
import urllib.parse
import os
import sys
import hashlib
import requests

DEVNULL = subprocess.DEVNULL
DEBUG = False

PLACEHOLDER = os.path.expanduser("~/icons/tv.png")  # fallback if no art
CACHE_DIR = os.path.expanduser("~/.cache/waybar-mpris-art")
CACHE_FILE = os.path.expanduser("~/.cache/waybar-current-player")
CACHE_MAX_FILES = 10
os.makedirs(CACHE_DIR, exist_ok=True)

def debug(*args):
    if DEBUG:
        print("[DEBUG]", *args, file=sys.stderr)

def list_players():
    try:
        out = subprocess.check_output(["playerctl", "-l"], text=True, stderr=DEVNULL).strip()
        return out.splitlines() if out else []
    except subprocess.CalledProcessError:
        return []

def get_art_url(player):
    templates = ["{{mpris:artUrl}}", "{{artUrl}}", "{{albumArtUrl}}", "{{xesam:url}}"]
    for t in templates:
        try:
            val = subprocess.check_output(
                ["playerctl", "-p", player, "metadata", "--format", t],
                text=True, stderr=DEVNULL
            ).strip()
            if val:
                return val
        except subprocess.CalledProcessError:
            continue
    return ""

def normalize_file_url(u):
    if u.startswith("file://"):
        path = urllib.parse.unquote(u[7:])
        return path
    return u

def clean_cache():
    files = [os.path.join(CACHE_DIR, f) for f in os.listdir(CACHE_DIR) if os.path.isfile(os.path.join(CACHE_DIR, f))]
    files.sort(key=lambda f: os.path.getmtime(f), reverse=True)  # newest first
    if len(files) <= CACHE_MAX_FILES:
        return
    for old_file in files[CACHE_MAX_FILES:]:
        try:
            os.remove(old_file)
        except Exception as e:
            debug("Failed to remove cached file:", old_file, e)

def download_remote_image(url):
    try:
        url_hash = hashlib.md5(url.encode()).hexdigest()
        ext = os.path.splitext(urllib.parse.urlparse(url).path)[1] or ".png"
        cached_file = os.path.join(CACHE_DIR, url_hash + ext)
        if os.path.exists(cached_file):
            return cached_file

        r = requests.get(url, stream=True, timeout=5)
        r.raise_for_status()
        with open(cached_file, "wb") as f:
            for chunk in r.iter_content(8192):
                f.write(chunk)
        clean_cache()
        return cached_file
    except Exception as e:
        debug("Failed to download image:", e)
        return PLACEHOLDER

def main():
    players = list_players()
    if not players:
        print(PLACEHOLDER)
        return

    # читаем кэш (тот же, что в media_text.py)
    chosen = None
    if os.path.exists(CACHE_FILE):
        with open(CACHE_FILE) as f:
            cached = f.read().strip()
            if cached in players:
                chosen = cached

    # fallback — если кэш пустой/невалидный
    if not chosen:
        chosen = players[0]

    art_url = get_art_url(chosen)
    if art_url:
        art_path = normalize_file_url(art_url)
        if os.path.exists(art_path):
            print(art_path)
            return
        elif (art_url.startswith("http://") or art_url.startswith("https://")) and any(i in art_url.lower() for i in [".png", ".jpg", ".jpeg", ".gif", ".webp"]):
            print(download_remote_image(art_url))
            return

    print(PLACEHOLDER)

if __name__ == "__main__":
    main()
