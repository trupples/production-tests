#!/bin/bash

# Wrapper script for doing a production cycle/routine for FMCOMMS4
# This script handles
#
# Can be called with:  ./production_FMCOMMS4.sh
#

SCRIPT_DIR="$(readlink -f $(dirname $0))"
ScriptLoc="$(readlink -f "$0")"

source $SCRIPT_DIR/lib/production.sh
source $SCRIPT_DIR/lib/utils.sh

while true; do
	echo_blue "Please enter your choice: "
	options=("DCXO Calibration Test" "FMCOMMS4 Test" "Power-Off Carrier" "Power-Off Pi")
	select opt in "${options[@]}"; do
    		case $REPLY in
			1)
				wait_for_board_online
				get_board_serial
				echo_blue "Starting FMCOMMS4 Calibration Test"
				production "crr" "$opt" "FMCOMMS4"
				break ;;
			2)
				wait_for_board_online
				get_board_serial
				echo_blue "Starting FMCOMMS4 Test"
				production "crr" "$opt" "FMCOMMS4"
				break ;;
			3)
				wait_for_board_online
				ssh_cmd "sudo poweroff &>/dev/null"
				break ;;
			
			4)
				enforce_root
				poweroff
				break 2 ;;
			*) echo "invalid option $REPLY";;
    		esac
	done
done
