#!/bin/bash

IMG1="$HOME/.config/sway/wallpaper1.jpg"
curl -s -L "https://picsum.photos/1920/1080" -o "$IMG1"

# Kill old swaybg so we don’t stack wallpapers
pkill swaybg

# Check for HDMI output
if swaymsg -t get_outputs | grep -q "HDMI-A-1"; then
    IMG2="$HOME/.config/sway/wallpaper2.jpg"
    curl -s -L "https://picsum.photos/1920/1080" -o "$IMG2"
    swaybg -o eDP-1 -i "$IMG1" -m fill &
    swaybg -o HDMI-A-1 -i "$IMG2" -m fill &
else
    swaybg -o eDP-1 -i "$IMG1" -m fill &
fi
