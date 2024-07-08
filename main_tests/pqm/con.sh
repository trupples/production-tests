#!/bin/bash

if ! command -v picocom &> /dev/null; then
    echo "picocom could not be found, please install it"
    exit 1;
fi


SERIAL_DEVICE="/dev/ttyACM0"
BAUD_RATE="115200"

send_command(){
    local command="$1"
    echo "$command"> "$PICOCOM_PIPE"
}

SESSION="picocom_session"
PICOCOM_PIPE="/tmp/picocom_pipe"
mkfifo "$PICOCOM_PIPE"
tmux new-session -d -s "$SESSION" "picocom -b "$BAUD_RATE" "$SERIAL_DEVICE" < "$PICOCOM_PIPE"" &
PICOCOM_PID=$?

clean_up(){
    tmux kill-session -t "$SESSION"
    rm -f "$PICOCOM_PIPE"
}

trap clean_up   EXIT

while true; do
    read -r -n 1 -p "Press y/n" input
    echo ""
    if [[ "$input" == "y" ]]; then
        send_command "y"
    else
        send_command "n"
    fi
done
