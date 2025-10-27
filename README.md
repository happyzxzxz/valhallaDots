
## VA-11 HALL-A inspired dots with sddm and grub themes
SDDM theme was made with [Silent](https://github.com/uiriansan/SilentSDDM) cus I'm lazy and it's not very usable if you have more than one user and change them constantly. <p>
Stuff (mostly css) may break if not on 1920x1080, sorry for that, should be fixable for everything if you really want to use it
### Screenshots
| Workspaces  | Grub/SDDM |
| ------------- | ------------- |
| ![workspace1](https://github.com/happyzxzxz/valhallaDots/blob/main/screenshots/workspace1.png?raw=true)  | ![grub](https://github.com/happyzxzxz/valhallaDots/blob/main/screenshots/grub.png?raw=true)  |
| ![workspace2](https://github.com/happyzxzxz/valhallaDots/blob/main/screenshots/workspace2.png?raw=true)  | ![sddm](https://github.com/happyzxzxz/valhallaDots/blob/main/screenshots/sddm_screen_1.png?raw=true)  |
### What's used in here
|Part|Name|
|--|--|
|Compositor|[Hyprland](https://github.com/hyprwm/Hyprland)|
|Bar|[Waybar](https://github.com/Alexays/Waybar)|
|App launcher|[Vicinae](https://github.com/vicinaehq/vicinae)|
|Notifications|[Mako](https://github.com/emersion/mako)|
|Lock|[Hyprlock](https://github.com/hyprwm/hyprlock/)|
|Terminal|[Kitty](https://github.com/kovidgoyal/kitty)|
|Power menu|[Wlogout](https://github.com/ArtsyMacaw/wlogout)|
|Text editor|[VSCode](https://code.visualstudio.com/) and [Zeditor](https://zed.dev/)|
|VSCode theme|[My own](https://marketplace.visualstudio.com/items?itemName=karasevuy.va-11-hall-a-inspired-theme) + [Iconsolata](https://fonts.google.com/specimen/Inconsolata)|
|Zeditor theme|[Duskfox blurred](https://zed.dev/extensions/nvim-nightfox)|
|File manager|[Yazi](https://github.com/sxyazi/yazi)|
|Wallpapers|[swww](https://github.com/LGFae/swww)|
|GTK theme|[Tokyonight](https://github.com/Fausto-Korpsvart/Tokyonight-GTK-Theme) + [CBPW Font](https://www.dafont.com/cyberpunkwaifus.font)|
|[SDDM](https://wiki.archlinux.org/title/SDDM) theme|Can find in here|
|Grub theme|Can find in here|
|Web browser|[Firefox](https://www.firefox.com/en-US/)|
|Firefox theme|[Textfox](https://github.com/sheeeng/adriankarlen-textfox/blob/main/readme.md) + [Colors](https://color.firefox.com/?theme=XQAAAAIZAQAAAAAAAABBKYhm849SCia3ftKEGccwS-xMDPr6QjyjB45W7s1iIrDvVaYoZsTt435quL77NpKNXOiEBW9XzRKM3iEUw_DVsfcURsvuj49T9-mcIwM9uHfj0YsBCkfKEwqNkT7Nm0UI1W71UV1KkBM3rz1dbf97O4h3yVi4ooIvUG5qoXNA-RirnAw0B5IFSP3qXZuj9ChAd_BXtJg6q0fWmYPaCy6_rP7Bq7zzOdv_Y7_7AA) (need extension)|

I think that's mostly it. Keep in mind that all of this stuff you should install yourself if you want to, in this repo you can find only dots or themes. Installation script will ask if you want to install SDDM or GRUB themes tho (doesn't check for installation)
###
### Installation

    git clone https://github.com/happyzxzxz/valhallaDots
    cd valhallaDots

    chmod +x install.sh
    ./install.sh
Don't forget to change `~/.config/hypr/hyprland.conf` for your configuration

### More about grub theme
It should work fine, but if your resolution is something else than **1920x1080** then you need to change font size:

    chmod +x changeFont.sh
    sudo ./changeFont.sh <size>
Where `<size>` is your font size. Default for FullHD is **42**