#!/bin/bash
 
# Define ignition gpio
IGN_PIN=23
 
# predefine gpio state (up = high)
sudo /usr/bin/gpio -g mode $IGN_PIN up
 
while true; do
    if [ $IGN_PIN -ne 0 ]; then
        IGN_GPIO=`gpio -g read $IGN_PIN`
        if [ $IGN_GPIO -ne 1 ] ; then
            if [ ! -f /tmp/ignition_on ]; then
                touch /tmp/ignition_on
                /sbin/shutdown -c && echo 0 > /sys/class/backlight/rpi_backlight/bl_power # turn the pi screen back on
				/bin/echo -e 'connect XX:XX:XX:XX:XX:XX \n quit \n' | bluetoothctl # reconnect to bt. Modify to match your phone's mac ID
				
            fi
        else
            if [ -f /tmp/ignition_on ]; then
                rm /tmp/ignition_on
                /sbin/shutdown --poweroff 58 && echo 58 > /sys/class/backlight/rpi_backlight/bl_power # turn the pi screen off
                /bin/echo -e 'remove XX:XX:XX:XX:XX:XX \n quit \n' | bluetoothctl # disconnect bt. Modify to match your phone's mac ID
            fi
        fi
    fi
    sleep 1
done