killall polybar
sleep 1

# Network interfaces
export ETH=$(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n' | grep ^e)
export WLAN=$(find /sys/class/net -type l -not -lname '*virtual*' -printf '%f\n' | grep ^w)
# Primary bar
polybar primary 2>&1 | tee -a /tmp/polybar1.log & disown

# Secondary bar
MONITOR_PRIMARY=$(polybar -m|head -1|sed -e 's/:.*$//g')
export MONITOR_SECONDARY=$(polybar -m|tail -1|sed -e 's/:.*$//g')

# Is there a second monitor?
if [ $MONITOR_PRIMARY != $MONITOR_SECONDARY ]; then
    polybar secondary 2>&1 | tee -a /tmp/polybar2.log & disown
fi
