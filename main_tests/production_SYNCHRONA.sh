#!/bin/bash

# Wrapper script for doing a production cycle/routine for a rfsom-box.
# This script handles
#
# Can be called with:  ./production_rfsom-box.sh
#

SCRIPT_DIR="$(readlink -f $(dirname $0))"
ScriptLoc="$(readlink -f "$0")"

source $SCRIPT_DIR/lib/production.sh
source $SCRIPT_DIR/lib/utils.sh

while true; do
	echo_blue "Please enter your choice: "
	options=("Synchrona Production Test" "Power-Off Synchrona" "Power-Off Pi")
	select opt in "${options[@]}"; do
    		case $REPLY in
			1)
				wait_for_board_online
				get_board_serial
				echo_blue "Starting Synchrona Test"
				production "crr" "$opt" "SYNCHRONA"
				break ;;
			2)
				wait_for_board_online
				ssh_cmd "sudo poweroff &>/dev/null"
				break ;;
			3)
				enforce_root
				poweroff
				break 2 ;;
        		*) echo "invalid option $REPLY";;
    		esac
	done
done
