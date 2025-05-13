killall waybar
sleep 1

outputs=($(swaymsg -t get_outputs | grep -A 5 '"name":' | grep '"name":' | awk -F'"' '{print $4}'))

echo $outputs
export MONITOR_PRIMARY=${outputs[0]}
export MONITOR_SECONDARY=${outputs[1]}

envsubst < ~/.config/waybar/config.jsonc > ~/.config/waybar/config.waybar.jsonc

waybar -c ~/.config/waybar/config.waybar.jsonc
# # Network interfaces
# export ETH=$(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n' | grep ^e)
# export WLAN=$(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n' | grep ^w)
# # Primary bar
# polybar primary 2>&1 | tee -a /tmp/polybar1.log & disown
#
# # Secondary bar
# MONITOR_PRIMARY=$(polybar -m|head -1|sed -e 's/:.*$//g')
# export MONITOR_SECONDARY=$(polybar -m|tail -1|sed -e 's/:.*$//g')
#
# # Is there a second monitor?
# if [ $MONITOR_PRIMARY != $MONITOR_SECONDARY ]; then
#     polybar secondary 2>&1 | tee -a /tmp/polybar2.log & disown
# fi
