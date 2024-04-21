#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh

MODE="$1"
case $MODE in
	"Synchrona Production Test")
		# Copy all test files + device tree to the DUT
		sshpass -p "analog" rsync -az -vP $SCRIPT_DIR analog@analog.local:~/synch
		sshpass -p "analog" scp $SCRIPT_DIR/rpi-ad9545-hmc7044.dtbo root@analog.local:/boot/overlays/
		sshpass -p "analog" scp $SCRIPT_DIR/rpi-ad9545-hmc7044.dtbo root@analog.local:/etc/raspap/synchrona/

		ssh_cmd "sudo raspi-config noint do_expand_rootfs"

		ssh_cmd "sudo /home/analog/synch/synch_test.sh $BOARD_SERIAL" || {
			handle_error_state "$BOARD_SERIAL"
			exit 1
		}

		$SCRIPT_DIR/uart_test.sh || {
			handle_error_state "$BOARD_SERIAL"
			exit 1
		}

		$SCRIPT_DIR/spi_test.sh || {
			handle_error_state "$BOARD_SERIAL"
			exit 1
		}

		$SCRIPT_DIR/misc_test.sh || {
			handle_error_state "$BOARD_SERIAL"
			exit 1
		}
	;;
esac
