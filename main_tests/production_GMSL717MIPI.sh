#!/bin/bash

export SCRIPT_DIR="$(readlink -f $(dirname $0))"

source $SCRIPT_DIR/lib/production.sh
source $SCRIPT_DIR/lib/utils.sh

while true; do
	echo_blue "Please enter your choice: "
	options=("GMSL717MIPI Test" "Power-Off Carrier" "Power-Off Pi")
	select opt in "${options[@]}"; do
		case $REPLY in
			1)
				wait_for_board_online
				export BOARD_SERIAL=$(get_board_serial)
				echo_blue "Starting GMSL717MIPI Test"
				production "crr" "$opt" "GMSL717MIPI"
				break ;;
			2)
				wait_for_board_online
				ssh_cmd "poweroff &>/dev/null"
				break ;;
			3)
				enforce_root
				poweroff
				break ;;

			*) echo "invalid option $REPLY";;
		esac
	done
done

