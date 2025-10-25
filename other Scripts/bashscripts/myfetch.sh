#!/bin/sh

# Check the $TERM environment variable
if [ "$TERM" = "xterm-kitty" ]; then
    # If it's Kitty, use the kitty config
    fastfetch -c ~/.config/fastfetch/kitty-config.jsonc
else
    # For any other terminal, use the chafa config
    fastfetch -c ~/.config/fastfetch/alac-config.jsonc
fi
