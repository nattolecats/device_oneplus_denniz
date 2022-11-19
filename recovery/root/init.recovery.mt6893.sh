#!/system/bin/sh

echo 1022 > /sys/class/leds/lcd-backlight/brightness
setprop ro.recovery.ui.margin_height 150
setprop ro.recovery.ui.animation_fps 60
setprop ro.recovery.ui.margin_width 50
