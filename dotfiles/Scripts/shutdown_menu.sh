#!/usr/bin/env bash
#
# Use rofi to change system runstate thanks to systemd.
#
# Based on original script by Benjamin Chrétien, simplified for rofi-only use.

#######################################################################
#                          BEGIN CONFIG                               #
#######################################################################

# Custom lock script (optional, uncomment and set if you use one)
# LOCKSCRIPT="i3lock-extra -m pixelize"
# Example with default i3lock:
# LOCKSCRIPT="i3lock --color=000000" # Change color as needed

# Rofi appearance colors (can be overridden by Rofi theme)
# These are fallback colors if your rofi theme doesn't define them or you prefer inline.
FG_COLOR="${FG_COLOR:-#bbbbbb}" # Foreground text color
BG_COLOR="${BG_COLOR:-#111111}" # Background color
HLFG_COLOR="${HLFG_COLOR:-#111111}" # Highlighted foreground text color
HLBG_COLOR="${HLBG_COLOR:-#bbbbbb}" # Highlighted background color
BORDER_COLOR="${BORDER_COLOR:-#222222}" # Border color

# Rofi main menu options
# -theme-str: Injects CSS-like rules directly. Adjust width/border/scrollbar as desired.
# -location 3: Positions the menu (e.g., center-right, see rofi man page for locations).
# -hover-select: Automatically highlights entry under mouse.
# -me-select-entry '': Selects entry immediately on hover.
# -me-accept-entry 'MousePrimary': Accepts selected entry on left mouse click.

#ROFI_MAIN_OPTIONS=(
#    -theme-str 'window {width: 13%; border: 2; height: 38%;} listview {scrollbar: false;}'
#    -location 3
#    -hover-select
#    -me-select-entry ''
#    -me-accept-entry 'MousePrimary'
#)

# Rofi confirmation dialog options (e.g., for "Are you sure you want to Shutdown?")
# These will inherit colors from main options but can be customized.
ROFI_CONFIRM_OPTIONS=(
    -dmenu
    -i
    -lines 7
    -hover-select
    -me-select-entry ''
    -me-accept-entry 'MousePrimary'
)

# Whether to ask for user's confirmation for certain actions
ENABLE_CONFIRMATIONS=${ENABLE_CONFIRMATIONS:-true} # Set to 'false' to disable confirmations

#######################################################################
#                           END CONFIG                                #
#######################################################################

# Check if systemctl exists
if ! command -v systemctl &> /dev/null; then
    echo "Error: systemctl not found. This script requires systemd." >&2
    exit 1
fi

# Check if rofi exists
if ! command -v rofi &> /dev/null; then
    echo "Error: rofi not found. Please install rofi." >&2
    exit 1
fi

# Define menu actions and their corresponding system commands
declare -A menu=(
    ["Lock       󰌾"]="${LOCKSCRIPT:-i3lock --color=${BG_COLOR#"#"}}" # Uses LOCKSCRIPT if defined, else default i3lock
    ["Logout     󰗽"]="i3-msg exit"
    ["Suspend    󰿅"]="systemctl suspend"
    ["Hibernate  󰐦"]="systemctl hibernate"
    ["Reboot     󰜉"]="systemctl reboot"
    ["Shutdown   "]="systemctl poweroff"
    ["Cancel     󰜺"]="" # Option to close menu without action
)

# Actions that will trigger a confirmation dialog
menu_confirm_actions="Shutdown Reboot Hibernate Suspend Logout" # Note: Lock is usually instant

# Prepare Rofi color arguments
#rofi_color_args=(
#    -bc "${BORDER_COLOR}"
#    -bg "${BG_COLOR}"
#    -fg "${FG_COLOR}"
#    -hlfg "${HLFG_COLOR}"
#    -hlbg "${HLBG_COLOR}"
#)

# Generate list of menu options for Rofi, sorted alphabetically
menu_options=$(printf '%s\n' "${!menu[@]}" | sort)

# Launch Rofi main menu
#selected_action=$(echo -e "$menu_options" | rofi -dmenu -p "Power Menu" lines "${#menu[@]}" "${rofi_color_args[@]}" "${ROFI_MAIN_OPTIONS[@]}")
selected_action=$(echo -e "$menu_options" | rofi -dmenu \
    -p "Power Menu" \
    -no-config \
    -theme ~/.config/rofi/themes/powermenu.rasi \
    -hover-select \
    -me-select-entry '' \
    -me-accept-entry 'MousePrimary')


# Execute the selected action
if [[ -n "$selected_action" && -n "${menu[$selected_action]}" ]]; then # If an action was selected and it's not "Cancel"
    execute_action=true
    if [[ "$ENABLE_CONFIRMATIONS" = true && "$menu_confirm_actions" =~ (^|[[:space:]])"$selected_action"($|[[:space:]]) ]]; then
        # Ask for confirmation
        confirmed=$(echo -e "Yes\nNo" | rofi -p "Confirm ${selected_action}?" \
            "${rofi_color_args[@]}" "${ROFI_CONFIRM_OPTIONS[@]}")
        
        if [[ "$confirmed" != "Yes" ]]; then
            execute_action=false
        fi
    fi

    if [[ "$execute_action" = true ]]; then
        # Execute the command, prefix with i3-msg for i3-specific commands
        if [[ "$selected_action" == "Lock" || "$selected_action" == "Logout" ]]; then
            i3-msg -q "exec ${menu[$selected_action]}"
        else
            # For systemd commands, directly execute
            ${menu[$selected_action]}
        fi
    fi
fi
