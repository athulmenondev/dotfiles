#!/bin/bash

# === Cyberpunk Colors ===
NEON_CYAN="00faffff"
NEON_PINK="ff00d4ff"
NEON_PURPLE="9d00ffff"
NEON_BLUE="0055ffff"

# Fonts
TIME_FONT="Ace of Swords 3D Italic"
DATE_FONT="Google Sans"

# Wallpaper
WALL="/home/athul/Pictures/wallpaper.jpg"
BLURRED="/tmp/i3lock_cyber_blur.png"

# Blur wallpaper
convert "$WALL" -blur 0x10 "$BLURRED"

# === i3lock-color (compatible) ===
i3lock \
-i "$BLURRED" \
--clock \
--time-font="$TIME_FONT" \
--date-font="$DATE_FONT" \
--time-size=170 \
--date-size=40 \
--time-color=$NEON_CYAN \
--date-color=$NEON_PINK \
--time-pos="w/2:h/2 - 80" \
--date-pos="w/2:h/2 + 40" \
--time-str="%H:%M" \
--date-str="%A, %d %b" \
\
--insidever-color=00000000 \
--ringver-color=00000000 \
--insidewrong-color=00000000 \
--ringwrong-color=$NEON_PINK \
\
--inside-color=00000000 \
--ring-color=00000000 \
--line-color=00000000 \
--separator-color=00000000 \
\
--verif-color=$NEON_BLUE \
--wrong-color=$NEON_PINK \
--layout-color=$NEON_PINK \
--keyhl-color=$NEON_CYAN \
--bshl-color=$NEON_PINK \
\
--blur 5 \
-n
