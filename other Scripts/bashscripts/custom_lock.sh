#!/bin/bash

pkill -x i3lock
sleep 0.1


# Path to original wallpaper
WALL="/home/athul/Pictures/wallpaper.jpg"
BLURRED="/tmp/i3lock_blurred.png"

# Load pywal colors (BASH compatible)
. ~/.cache/wal/colors.sh

# Transparent
BLANK='#00000000'

# Pywal colors
TEXT="$color10"
WRONG="$color1"
HIGHLIGHT="$color4"

# Custom fonts
#TIME_FONT="Ace of Swords 3D Italic"
TIME_FONT="911 Porscha Bold, Bold 14"
DATE_FONT="Google Sans"
rm -f "$BLURRED"
# Create blurred wallpaper
convert "$WALL" -blur 0x8 "$BLURRED"

# Run i3lock
i3lock \
-i "$BLURRED" \
--insidever-color=$BLANK \
--ringver-color=$BLANK \
\
--insidewrong-color=$BLANK \
--ringwrong-color=$BLANK \
\
--inside-color=$BLANK \
--ring-color=$BLANK \
--line-color=$BLANK \
--separator-color=$BLANK \
\
--verif-color=$TEXT \
--wrong-color=$WRONG \
--time-color=$TEXT \
--date-color=$TEXT \
--layout-color=$TEXT \
--keyhl-color=$HIGHLIGHT \
--bshl-color=$WRONG \
\
--clock \
--time-font="$TIME_FONT" \
--date-font="$DATE_FONT" \
--time-size=150 \
--date-size=30 \
--time-str="%H:%M:%S" \
--date-str=$"%A, %d %b" \
--greeter-text="Athul S Menon" \
--greeter-color=$TEXT \
--greeter-size=35 \
--greeter-pos="tx:0:20"
-n

