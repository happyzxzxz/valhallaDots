#!/bin/bash

if command -v hyprctl &>/dev/null; then
    RESOLUTION=$(hyprctl monitors | grep -oP '([0-9]+x[0-9]+)' | head -n1)
elif command -v xrandr &>/dev/null; then
    RESOLUTION=$(xrandr | grep '*' | awk '{print $1}' | head -n1)
elif command -v xdpyinfo &>/dev/null; then
    RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')
else
    echo "Could not detect resolution, defaulting to 1920x1080"
    RESOLUTION="1920x1080"
fi

echo "Detected resolution: $RESOLUTION"

WAYBAR_VARIANTS_DIR="./waybarVariants"
TARGET_DIR="./dots/waybar"

if [[ ! -d "${WAYBAR_VARIANTS_DIR}/${RESOLUTION}" ]]; then
    echo "No variant found for ${RESOLUTION}, using 1920x1080 instead."
    RESOLUTION="1920x1080"
fi

echo "Copying Waybar variant for ${RESOLUTION}..."
mkdir -p "$TARGET_DIR"
cp -r "${WAYBAR_VARIANTS_DIR}/${RESOLUTION}/"* "$TARGET_DIR/"

# Fix paths in Waybar style/config
sed -i "s#/home/karasevuy#$HOME#g" "${TARGET_DIR}/style.css"
sed -i "s#/home/karasevuy#$HOME#g" "${TARGET_DIR}/config.jsonc"

echo "Copied correct Waybar configuration for ${RESOLUTION}."

echo
read -rp "Do you want to set up the Waybar weather widget? (y/n): " setup_weather
if [[ "$setup_weather" =~ ^[Yy]$ ]]; then
    echo "You can get a free API key at: https://www.weatherapi.com (sign up required)"
    read -rp "Enter your WeatherAPI key or nothing to cancel: " WEATHER_KEY

    if [[ -n "$WEATHER_KEY" ]]; then
        WEATHER_SCRIPT="./dots/waybar/scripts/weather.py"

        if [[ -f "$WEATHER_SCRIPT" ]]; then
            echo "Setting your API key in ${WEATHER_SCRIPT}..."
            sed -i -E "s|^api_key *= *\"[^\"]*\"|api_key = \"${WEATHER_KEY}\"|" "$WEATHER_SCRIPT"
            echo "Weather API key has been set."
        else
            echo "Could not find ${WEATHER_SCRIPT}. Skipping weather setup."
        fi
    else
        echo "No key entered. Skipping weather widget setup."
    fi
else
    echo "Skipped weather widget setup."
fi


echo "Copying dotfiles... (don't forget to change hyprland.conf)"
cp -r ./icons "$HOME"
cp -r ./dots/* "$HOME/.config"


# Fonts
read -rp "Do you want to install fonts? (y/n): " install_fonts
if [[ "$install_fonts" =~ ^[Yy]$ ]]; then
    echo "Installing fonts... (needs root)"
    sudo mkdir -p /usr/share/fonts
    sudo cp ./fonts/* /usr/share/fonts
    echo "Fonts installed."
else
    echo "Skipped fonts installation."
fi

# SDDM Theme
read -rp "Do you want to install the SDDM theme? (y/n): " install_sddm
if [[ "$install_sddm" =~ ^[Yy]$ ]]; then
    echo "Installing SDDM theme... (needs root)"
    sudo cp -r ./sddm/valhalla /usr/share/sddm/themes/
    sudo cp ./sddm/sddm.conf /etc/
    echo "SDDM theme installed."
else
    echo "Skipped SDDM theme installation."
fi

# GRUB Theme
read -rp "Do you want to install the Grub theme? Only do this if your grub is in the /boot/grub/ (y/n): " install_grub
if [[ "$install_grub" =~ ^[Yy]$ ]]; then
    echo "Installing Grub theme.. (needs root)"
    sudo cp -r ./grub/valhalla /boot/grub/themes

    NEW_THEME="/boot/grub/themes/valhalla/theme.txt"

    # Replace or add GRUB_THEME in /etc/default/grub
    if grep -q "^GRUB_THEME=" /etc/default/grub; then
        sudo sed -i "s|^GRUB_THEME=.*|GRUB_THEME=\"$NEW_THEME\"|" /etc/default/grub
    else
        echo "GRUB_THEME=\"$NEW_THEME\"" | sudo tee -a /etc/default/grub
    fi

    # Update grub
    if command -v update-grub &>/dev/null; then
        sudo update-grub
    elif command -v grub-mkconfig &>/dev/null; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi

    echo "GRUB theme set to $NEW_THEME"
    echo "Don't forget to change fonts if not on 1920x1080!"
else
    echo "Skipped Grub theme installation."
fi

echo
echo "If you want, you can also install (see repo):"
echo "- firefox theme"
echo "- vs code theme"

echo "Done."
