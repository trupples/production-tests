#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh

MODE="$1"
case $MODE in
    "Erase Flash and System Test")
        sudo $SCRIPT_DIR/erase_flash.sh
	;& # bash 4+ fallthrough

    "System Test")
        # Upload and run test firmware
	$SCRIPT_DIR/firmware_prod.sh && {
		echo_blue "Firmware upload successful!"
	} || {
		echo_red "Error uploading firmware!"
		echo_blue "Note: Try power cycling the DUT by disconnecting and reconnecting the USB type C cable, then attempting the test again."
		exit 1
	}
        export tty=/dev/ttyACM0
        echo_blue "Serial self-test starting..."
        $SCRIPT_DIR/system_test.sh || {
            handle_error_state "$BOARD_SERIAL"
            exit 1
        }
        ;;

    *) echo "Invalid option $MODE" ;;

esac
