#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"
source "$SCRIPT_DIR/../lib/utils.sh"

MODE="$1"
case $MODE in
	"GMSL717MIPI Test")
		echo_blue 'Copying test files to carrier'
		sshpass -p "analog" scp -o StrictHostKeyChecking=accept-new -r "$SCRIPT_DIR/carrier_setup/" analog@ubuntu-gmsl522:carrier_setup/ || {
			echo_red "Could not copy test files to carrier"
			handle_error_state "$BOARD_SERIAL"
			exit 1;
		}

		echo_blue 'Initializing camera and checking test pattern'
		# initialize camera, take one test pattern frame, compare to md5 hash of test pattern to confirm it was properly received
		# MD5 suffices because we don't need any cryptographic guarantees, just a quick content check
		sshpass -p "analog" ssh analog@ubuntu-gmsl522 -- "cd carrier_setup; ./test_tpg.sh" && {
			echo_green "Test pattern received correctly"
			exit 0
		} || {
			echo_red "Test pattern not received correctly"
			handle_error_state "$BOARD_SERIAL"
			exit 1
		}
		;;

	*) echo "Invalid option $MODE" ;;
esac

