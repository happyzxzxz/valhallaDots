#!/bin/bash

# Fix path in waybar style
sed -i "s#/home/karasevuy#$HOME#g" "./dots/waybar/style.css"
sed -i "s#/home/karasevuy#$HOME#g" "./dots/waybar/config.jsonc"

echo "Copying dotfiles... (don't forget to change hyprland.conf)"
cp -r ./icons "$HOME"
cp -r ./dots/* "$HOME/.config"

# Ask about fonts
read -rp "Do you want to install fonts? (y/n): " install_fonts
if [[ "$install_fonts" =~ ^[Yy]$ ]]; then
    echo "Installing fonts... (needs root)"
    sudo mkdir /usr/share/fonts
    sudo cp ./fonts/* /usr/share/fonts
    echo "Fonts installed."
else
    echo "Skipped fonts installation."
fi

# Ask about SDDM theme
read -rp "Do you want to install the SDDM theme? (y/n): " install_sddm
if [[ "$install_sddm" =~ ^[Yy]$ ]]; then
    echo "Installing SDDM theme... (needs root)"
    sudo cp -r ./sddm/valhalla /usr/share/sddm/themes/
    sudo cp ./sddm/sddm.conf /etc/
    echo "SDDM theme installed."
else
    echo "Skipped SDDM theme installation."
fi

# Grub theme
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
else
    echo "Skipped Grub theme installation."
fi

echo "If you want, you can also install (see repo):"
echo "- firefox theme"
echo "- vs code theme"

echo "Done!"
