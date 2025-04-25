#!/bin/bash

IMG="$HOME/.config/i3/sh/wallpaper.jpg"

curl -s -L "https://picsum.photos/1920/1080" -o "$IMG"
feh --bg-fill "$IMG"
