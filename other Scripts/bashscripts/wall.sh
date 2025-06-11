#!/bin/bash

IMG1="$HOME/.config/i3/sh/wallpaper1.jpg"
curl -s -L "https://picsum.photos/1920/1080" -o "$IMG1"
sleep 2
if xrandr | grep "HDMI-1 connected"; then
    IMG2="$HOME/.config/i3/sh/wallpaper2.jpg"
    curl -s -L "https://picsum.photos/1920/1080" -o "$IMG2"
    feh --bg-fill "$IMG1" --bg-fill "$IMG2"
else
    feh --bg-fill "$IMG1"
fi