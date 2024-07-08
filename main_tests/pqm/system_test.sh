#!/bin/bash
SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh
RESULT=0

pushd $SCRIPT_DIR

# Run test.exc Except script in background, using fd 3,4 for communication
mkfifo fifo_in fifo_out
./test.exp <fifo_in >fifo_out &
exec 3>fifo_in
exec 4<fifo_out

popd

function clean_up() {
	rm $SCRIPT_DIR/fifo_in $SCRIPT_DIR/fifo_out
}

trap clean_up EXIT

function assert_line_is() {
	read -u 4 line;
	if [[ "$line" != "$1" ]]; then
		echo_red "FAILED"
		exit 1
	fi
}

function check_passfail() {
	read -u 4 line;
	if [[ "$line" == "pass" ]]; then
		echo_green "PASSED"
	else
		echo_red "FAILED"
		RESULT=1
	fi
}

assert_line_is "Uploading FW"
echo '[00] Uploading FW'

assert_line_is "UART"
echo '[01] UART test'
assert_line_is "pass" # UART MUST pass. If it fails, exit early.
echo_green "PASSED"

assert_line_is "RAM"
echo '[02] RAM test'
check_passfail

assert_line_is "FLASH"
echo '[03] FLASH test'
check_passfail

assert_line_is "LCD"
echo '[04] LCD test'
read -n 1 -p 'Is the display working (y/n)?' answer
echo $answer >&3
check_passfail

assert_line_is "RTC"
echo '[05] RTC test'
check_passfail

assert_line_is "SD card"
echo '[06] SD card test'
check_passfail

assert_line_is "led1"
echo '[07] LED & BUTTON test'
read -n 1 -p 'Is LED DS1 on (y/n)?' answer
echo $answer >&3
check_passfail

assert_line_is "led2"
read -n 1 -p 'Is LED DS2 on (y/n)?' answer
echo $answer >&3
check_passfail

assert_line_is "led3"
read -n 1 -p 'Is LED DS3 on (y/n)?' answer
echo $answer >&3
check_passfail

assert_line_is "led4"
read -n 1 -p 'Is LED DS4 on (y/n)? (This pin is also part of JTAG and may not work while the programmer is connected)' answer
echo $answer >&3
check_passfail

assert_line_is "button1"
echo 'Press button S1! (5 second timeout)'
check_passfail

assert_line_is "button2"
echo 'Press button S2! (5 second timeout)'
check_passfail

assert_line_is "button3"
echo 'Press button S3! (5 second timeout)'
check_passfail

assert_line_is "T1L"
echo '[08] T1L test'
check_passfail

assert_line_is "WIZ ETH"
echo '[09] WIZ ETH test'
check_passfail

assert_line_is "ADE9430"
echo '[10] ADE9430 test'
check_passfail

assert_line_is "t1lsocket"
echo '[11] T1L socket test'
read -u 4 ip
echo IP: $ip
echo 'NOT IMPLEMENTED! TODO: Connect via T1L to port 10000 and check that it echoes back properly!'

exit $RESULT

