#!/usr/bin/env bash
#
# changeFont.sh — create and apply a new GRUB font
# Usage: ./changeFont.sh <size>
#

set -e

# === CONFIG ===
FONT_NAME="CyberpunkWaifus"
FONT_SRC="fonts/${FONT_NAME}.ttf"
OUTPUT_DIR="grub/valhalla"
THEME_FILE_LOCAL="${OUTPUT_DIR}/theme.txt"
SYSTEM_THEME_DIR="/boot/grub/themes/valhalla"
THEME_FILE_SYSTEM="${SYSTEM_THEME_DIR}/theme.txt"

# === CHECK ARGUMENTS ===
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <font-size>"
    exit 1
fi

SIZE="$1"
if ! [[ "$SIZE" =~ ^[0-9]+$ ]]; then
    echo "Error: size must be a positive integer."
    exit 1
fi

# === CHECK FONT SOURCE ===
if [[ ! -f "$FONT_SRC" ]]; then
    echo "Error: font file not found at '$FONT_SRC'"
    exit 1
fi

# === ENSURE OUTPUT DIR EXISTS ===
mkdir -p "$OUTPUT_DIR"

# === GENERATE FONT ===
NEW_FONT_FILE="${FONT_NAME}${SIZE}.pf2"
NEW_FONT_PATH="${OUTPUT_DIR}/${NEW_FONT_FILE}"

echo "→ Generating GRUB font: ${NEW_FONT_PATH}"
grub-mkfont -s "$SIZE" -o "$NEW_FONT_PATH" "$FONT_SRC"

# === UPDATE THEME FILES ===
update_theme_file() {
    local theme_file="$1"
    if [[ ! -f "$theme_file" ]]; then
        echo "⚠️  Skipping missing file: $theme_file"
        return
    fi

    echo "→ Updating font reference in: $theme_file"
    # Replace occurrences like "CyberpunkWaifus 42" or "CyberpunkWaifus XX"
    sed -i -E "s|(${FONT_NAME})[[:space:]]*[0-9]+|\1 ${SIZE}|g" "$theme_file"
}

update_theme_file "$THEME_FILE_LOCAL"
update_theme_file "$THEME_FILE_SYSTEM"

# === COPY TO SYSTEM THEME (if present) ===
if [[ -d "$SYSTEM_THEME_DIR" ]]; then
    echo "→ Copying font to $SYSTEM_THEME_DIR/"
    cp "$NEW_FONT_PATH" "$SYSTEM_THEME_DIR/"
fi

echo "✅ Done!"
echo "New font: ${NEW_FONT_PATH}"
echo "Font reference updated to '${FONT_NAME} ${SIZE}' in theme files."
