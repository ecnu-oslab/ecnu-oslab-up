#!/bin/bash

led=/sys/class/leds/input1::capslock/brightness
interval=0.2

if [[ ! -f $led ]]; then
    echo "Cannot find leds" >&2
    exit
fi

switch_to() {
    echo $1 | sudo tee $led > /dev/null
}

status=$(cat $led)
origin=$status

# STFW: https://stackoverflow.com/questions/2129923/how-to-run-a-command-before-a-bash-script-exits
trap "switch_to $origin" EXIT

while true; do
    switch_to $((status ^= 1))
    sleep $interval
done

