#!/bin/bash
# ----------------------------------------
# Wallpaper Selector + Pywal Integration (Optimized)
# Instant Preview • Fast UI • Pywal After Confirmation
# ----------------------------------------

# --- ENVIRONMENT FIX ---
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# --- CONFIGURATION ---
dir="$HOME/Pictures/wallpapers/"             
permanent_copy_dir="$HOME/Pictures/"          
set_cmd="feh --bg-fill"                       
rofi_theme="$HOME/.config/rofi/themes/wallpaper-theme.rasi"
rofi_confirm_theme="$HOME/.config/rofi/themes/wallpaper-theme-options.rasi"
SCRIPT_PATH="$HOME/Files/Scripts/wsh.sh"      
post_script="/home/athul/Files/Scripts/post_wsh.sh"

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

apply_wallpaper() {
    $set_cmd "$1" &
}

apply_wal_and_post() {
    wal -i "$1"
    "$post_script"
}

set_permanent() {
    cp "$dir$chosen_wallpaper" "${permanent_copy_dir}wallpaper.jpg"
}

# --- MAIN LOGIC ---
original_wallpaper_path="${permanent_copy_dir}wallpaper.jpg"
original_wallpaper=""
[ -f "$original_wallpaper_path" ] && original_wallpaper="$original_wallpaper_path"

# Step 1: Selection
chosen_wallpaper=$(generate_rofi_list | rofi -dmenu -p "Select Wallpaper" -theme "$rofi_theme")
[ -z "$chosen_wallpaper" ] && exit 0

# Step 2: Instant Preview (NO WAL)
apply_wallpaper "$dir$chosen_wallpaper"

# --- FIXED SPACING ICON MENU ---
confirmation_options="   Go Back\n   Set for Session\n   Set Permanently"

# Step 3: Confirmation Dialog
chosen_action=$(echo -e "$confirmation_options" | rofi -dmenu -p "Confirm Action" -theme "$rofi_confirm_theme")

case "$chosen_action" in
    "   Go Back")
        if [ -n "$original_wallpaper" ]; then
            apply_wallpaper "$original_wallpaper"
        fi
        exec "$SCRIPT_PATH"
        ;;

    "   Set for Session")
        apply_wal_and_post "$dir$chosen_wallpaper"
        exit 0
        ;;

    "   Set Permanently")
        set_permanent
        apply_wal_and_post "$dir$chosen_wallpaper"
        exit 0
        ;;

    *)
        # If closed or invalid input: revert
        if [ -n "$original_wallpaper" ]; then
            apply_wallpaper "$original_wallpaper"
        fi
        exit 1
        ;;
esac
