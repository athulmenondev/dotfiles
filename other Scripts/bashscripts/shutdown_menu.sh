#!/usr/bin/env bash
#
# Power menu using Rofi + systemd + i3 integration

#######################################################################
#                          CONFIG                                      #
#######################################################################

LOCKSCRIPT="/home/athul/Files/Scripts/custom_lock.sh"

ENABLE_CONFIRMATIONS=true

ROFI_THEME="$HOME/.config/rofi/themes/powermenu.rasi"

ROFI_CONFIRM_OPTIONS=(
    -dmenu
    -i
    -lines 7
    -hover-select
    -me-select-entry ''
    -me-accept-entry 'MousePrimary'
)

#######################################################################
#                          PRECHECKS                                   #
#######################################################################

if ! command -v systemctl &> /dev/null; then
    echo "Error: systemctl not found." >&2
    exit 1
fi

if ! command -v rofi &> /dev/null; then
    echo "Error: rofi not found." >&2
    exit 1
fi

#######################################################################
#                         MENU DEFINITION                              #
#######################################################################

declare -A menu=(
    ["Lock       󰌾"]="$LOCKSCRIPT"
    ["Logout     󰗽"]="i3-msg exit"
    ["Suspend    󰿅"]="systemctl suspend"
    ["Hibernate  󰐦"]="systemctl hibernate"
    ["Reboot     󰜉"]="systemctl reboot"
    ["Shutdown   "]="systemctl poweroff"
    ["Cancel     󰜺"]=""
)

menu_confirm_actions="Shutdown Reboot Hibernate Suspend Logout"

#######################################################################
#                         MAIN MENU                                    #
#######################################################################

# Sort menu entries
menu_options=$(printf '%s\n' "${!menu[@]}" | sort)

selected_action=$(echo -e "$menu_options" | rofi -dmenu \
    -p "Power Menu" \
    -no-config \
    -theme "$ROFI_THEME" \
    -hover-select \
    -me-select-entry '' \
    -me-accept-entry 'MousePrimary')

# Stop if nothing selected
[[ -z "$selected_action" ]] && exit 0

# Extract the associated command
action_cmd="${menu[$selected_action]}"

# Cancel option
[[ -z "$action_cmd" ]] && exit 0

#######################################################################
#                        FIX → Strip icon                              #
#######################################################################

clean_action=$(echo "$selected_action" | awk '{print $1}')

#######################################################################
#                 Confirmation Dialog (Fixed)                           #
#######################################################################

if [[ "$ENABLE_CONFIRMATIONS" = true && "$menu_confirm_actions" =~ (^|[[:space:]])"$clean_action"($|[[:space:]]) ]]; then

    confirm=$(echo -e "Yes\nNo" | rofi \
        -p "Confirm ${clean_action}?" \
        -theme "$ROFI_THEME" \
        "${ROFI_CONFIRM_OPTIONS[@]}")

    [[ "$confirm" != "Yes" ]] && exit 0
fi

#######################################################################
#                     EXECUTION LOGIC                                   #
#######################################################################

if [[ "$clean_action" == "Lock" || "$clean_action" == "Logout" ]]; then
    # i3 commands must be executed through i3-msg
    i3-msg -q "exec $action_cmd"
else
    # systemd commands can run directly
    $action_cmd
fi
