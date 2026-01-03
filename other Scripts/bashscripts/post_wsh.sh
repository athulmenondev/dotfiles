#!/bin/bash

# --- Define user-specific paths ---
USER_HOME="/home/athul"

# --- Set environment variables using the full path ---
export PATH="$USER_HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$PATH"
export DISPLAY=:0
export XAUTHORITY="$USER_HOME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# --- Run your command ---
walogram -B

# --- Define the full path to the file to be removed ---
CACHE_FILE="$USER_HOME/.cache/wal/pywall_chrome/chrome_pywall_theme/Cached Theme.pak"

# --- Check if the file exists, then remove it ---
# We use -f to force removal and ignore errors if it's already gone.
if [ -f "$CACHE_FILE" ]; then
    rm -f "$CACHE_FILE"
fi

# --- Execute the next script using the full path ---
exec "$USER_HOME/Files/Scripts/pywall-chrome.sh"
