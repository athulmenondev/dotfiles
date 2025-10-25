#!/bin/bash

# A robust script to manage iwd Wi-Fi connections with Rofi

# Set the device name directly to avoid parsing issues.
device="wlan0"

# --- The rest of the script remains the same ---

# Scan for networks. This is good practice to ensure the list is up to date.
iwctl station "$device" scan

# Get the list of networks, clean up the output from iwctl, and pipe it into Rofi
ssid=$(iwctl station "$device" get-networks | sed '1,4d' | sed '$d' | awk '{print $2}' | rofi -dmenu -i -p "󰖩 Select WiFi" -theme ~/.config/rofi/themes/powermenu.rasi)

# Exit if the user cancelled Rofi (no network selected)
if [ -z "$ssid" ]; then
    exit
fi

# Check if the selected network is already a known network
if iwctl known-networks list | grep -q "$ssid"; then
    # If so, connect to it directly
    iwctl station "$device" connect "$ssid"
else
    # If it's a new network, ask for the password using Rofi's password mode
    password=$(rofi -dmenu -password -p " Password for $ssid" -theme ~/.config/rofi/themes/powermenu.rasi)
    
    # Exit if the user cancelled the password entry
    if [ -z "$password" ]; then
        exit
    fi

    # Connect to the new network using the provided password
    iwctl --passphrase "$password" station "$device" connect "$ssid"
fi
