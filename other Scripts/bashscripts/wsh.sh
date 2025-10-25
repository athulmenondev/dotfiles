#!/bin/bash
# ----------------------------------------
# Wallpaper Selector + Pywal Integration
# Works from i3 keybind and terminal
# ----------------------------------------

# --- ENVIRONMENT FIX ---
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# --- CONFIGURATION ---
dir="$HOME/Pictures/wallpapers/"               # Wallpaper folder (must end with /)
permanent_copy_dir="$HOME/Pictures/"           # Folder to copy the chosen wallpaper to
set_cmd="feh --bg-fill"                        # Wallpaper setter
rofi_theme="$HOME/.config/rofi/themes/wallpaper-theme.rasi"
rofi_confirm_theme="$HOME/.config/rofi/themes/wallpaper-theme-options.rasi"
SCRIPT_PATH="$HOME/Files/Scripts/wsh.sh"       # Absolute path to this script

# --- VALIDATION ---
cd "$dir" || { echo "Error: Wallpaper directory not found at '$dir'"; exit 1; }
[ ! -f "$rofi_theme" ] && { echo "Error: Rofi theme not found at '$rofi_theme'"; exit 1; }
[ ! -f "$rofi_confirm_theme" ] && { echo "Error: Rofi confirmation theme not found at '$rofi_confirm_theme'"; exit 1; }

# --- FUNCTIONS ---
generate_rofi_list() {
    for wallpaper_file in *; do
        [[ -f "$wallpaper_file" ]] && printf "%s\0icon\x1f%s\n" "$wallpaper_file" "$dir$wallpaper_file"
    done
}

set_wallpaper_and_wal() {
    local image_path="$1"
    $set_cmd "$image_path" &
    wal -i "$image_path"
}

set_permanent() {
    cp "$dir$chosen_wallpaper" "${permanent_copy_dir}wallpaper.jpg"
}

# --- MAIN LOGIC ---
original_wallpaper_path="${permanent_copy_dir}wallpaper.jpg"
original_wallpaper=""
[ -f "$original_wallpaper_path" ] && original_wallpaper="$original_wallpaper_path"

# Step 1: Wallpaper selection
chosen_wallpaper=$(generate_rofi_list | rofi -dmenu -p "Select Wallpaper" -theme "$rofi_theme")
[ -z "$chosen_wallpaper" ] && exit 0

# Step 2: Preview + apply Pywal
set_wallpaper_and_wal "$dir$chosen_wallpaper"

# Step 3: Confirmation dialog
confirmation_options=" Go Back\n Set for Session\n Set Permanently"
chosen_action=$(echo -e "$confirmation_options" | rofi -dmenu -p "Confirm Action" -theme "$rofi_confirm_theme")

case "$chosen_action" in
    " Go Back")
        [ -n "$original_wallpaper" ] && set_wallpaper_and_wal "$original_wallpaper"
        exec "$SCRIPT_PATH"
        ;;
    " Set for Session")
        exit 0
        ;;
    " Set Permanently")
        set_permanent
        exit 0
        ;;
    *)
        [ -n "$original_wallpaper" ] && set_wallpaper_and_wal "$original_wallpaper"
        exit 1
        ;;
esac
