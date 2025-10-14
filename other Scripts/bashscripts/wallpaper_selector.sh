#!/bin/bash

# A wallpaper changer script with a preview and confirmation step.
#
# 1. Select a wallpaper from a grid view.
# 2. A preview of the wallpaper is set.
# 3. A simple confirmation dialog asks what to do next.

# --- CONFIGURATION ---
dir="/home/$USER/Pictures/wallpapers/" # Your wallpapers folder. MUST end with a slash.
permanent_copy_dir="/home/$USER/Pictures/" # Directory to copy wallpapers to.
set_cmd="feh --bg-fill"
# The theme for the main wallpaper grid selector
rofi_theme="$HOME/.config/rofi/themes/wallpaper-theme.rasi"
# A simpler theme just for the confirmation dialog
rofi_confirm_theme="$HOME/.config/rofi/themes/wallpaper-theme-options.rasi"

# --- SCRIPT LOGIC ---

# Check if directories and theme files exist
cd "$dir" || { echo "Error: Wallpaper directory not found at '$dir'"; exit 1; }
[ ! -f "$rofi_theme" ] && { echo "Error: Rofi theme not found at '$rofi_theme'"; exit 1; }
[ ! -f "$rofi_confirm_theme" ] && { echo "Error: Rofi confirmation theme not found at '$rofi_confirm_theme'"; exit 1; }


# Function to generate the list of wallpapers for Rofi
generate_rofi_list() {
    for wallpaper_file in *; do
        if [[ -f "$wallpaper_file" ]]; then
            # Format: "filename\0icon\x1f/path/to/image.jpg"
            printf "%s\0icon\x1f%s\n" "$wallpaper_file" "$dir$wallpaper_file"
        fi
    done
}

# Store the path to the permanent wallpaper before we change anything
original_wallpaper_path="${permanent_copy_dir}wallpaper.jpg"
original_wallpaper=""
if [ -f "$original_wallpaper_path" ]; then
    original_wallpaper="$original_wallpaper_path"
fi


# Show the wallpaper selector using the grid theme
chosen_wallpaper=$(generate_rofi_list | rofi -dmenu -p "Select Wallpaper" -theme "$rofi_theme")

# Exit if the user pressed Esc in the wallpaper selector
if [ -z "$chosen_wallpaper" ]; then
    exit 0
fi

# --- PREVIEW ---
# Temporarily set the chosen wallpaper as a live preview
$set_cmd "$dir$chosen_wallpaper" &

# --- CONFIRMATION DIALOG ---
# Use Nerd Font icons for a nicer look.
confirmation_options=" Go Back\n Set for Session\n Set Permanently"
# Use the new, simpler theme for this confirmation step
chosen_action=$(echo -e "$confirmation_options" | rofi -dmenu -p "Confirm Action" -theme "$rofi_confirm_theme")

# Function to set the wallpaper permanently by copying it
set_permanent() {
    # The wallpaper is already set from the preview.
    # This function copies the selected file to a fixed name ('wallpaper.jpg'),
    # so a startup script can always point to the same file.
    cp "$dir$chosen_wallpaper" "${permanent_copy_dir}wallpaper.jpg"
}

# Handle the user's choice from the confirmation dialog
case "$chosen_action" in
    "   Go Back")
        # Revert to the original wallpaper if it was found
        if [ -n "$original_wallpaper" ]; then
            $set_cmd "$original_wallpaper" &
        fi
        # Re-run the script from the beginning
        exec "$0"
        ;;
    " 	 Set for Session")
        # The wallpaper is already set from the preview, so we just exit.
        exit 0
        ;;
    "   Set Permanently")
        set_permanent
        ;;
    *)
        # If user presses Esc on confirmation, revert to the original wallpaper.
        if [ -n "$original_wallpaper" ]; then
            $set_cmd "$original_wallpaper" &
        fi
        exit 1
        ;;
esac

