#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh

MODE="$1"
case $MODE in
    "Erase Flash")
        sudo $SCRIPT_DIR/erase_flash.sh
        ;;

    "System Test")
        # Upload and run test firmware
        export tty=/dev/ttyACM0
        echo_blue "Serial self-test starting..."
        $SCRIPT_DIR/system_test.sh || {
            handle_error_state "$BOARD_SERIAL"
            exit 1
        }
        ;;

    *) echo "Invalid option $MODE" ;;

esac
