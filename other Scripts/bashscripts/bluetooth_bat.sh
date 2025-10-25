#!/bin/bash

# Find the MAC address of the first connected Bluetooth device
CONNECTED_DEVICE_MAC=$(bluetoothctl devices Connected | head -n 1 | awk '{print $2}')

# If no device is connected, don't show anything
if [ -z "$CONNECTED_DEVICE_MAC" ]; then
    exit 0
fi

# Get the battery percentage from the device info
# The awk command extracts the number inside the parentheses, e.g., (100) -> 100
BATTERY_PERCENTAGE=$(bluetoothctl info "$CONNECTED_DEVICE_MAC" | grep "Battery Percentage" | awk -F '[()]' '{print $2}')

# If battery percentage is found, print it with an icon
if [ -n "$BATTERY_PERCENTAGE" ]; then
    echo " $BATTERY_PERCENTAGE%"
fi
