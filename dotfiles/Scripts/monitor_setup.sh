sleep 2
if xrandr | grep "HDMI-1 connected"; then
    xrandr --output HDMI-1 --auto --left-of eDP-1
fi