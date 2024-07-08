#!/bin/bash
SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh


check_display(){
	echo "[01] DIsplay test"
	read -n 1 -p "Is the display working (y/n)?" answer
	echo ""
	
	if [[ "$answer" =~ [yY] ]]; then
		echo_green "PASSED"
	else
		echo_red "FAILED"
		RESULT=1;
	fi
	
	sleep 1
}
declare -A LED_TESTS
declare -A BTN_TESTS

LED_TESTS["3,6"]="\t--> Is LED DS1 ON? [y/n]?"
LED_TESTS["3,7"]="\t--> Is LED DS2 ON? [y/n]?"
LED_TESTS["0,23"]="\t--> Is LED DS3 ON? [y/n]?"
LED_TESTS["0,27"]="\t--> Is LED DS4 ON? [y/n]? (This pin is also part of JTAG, while debug it might not work)"

BTN_TESTS["3,8"]="\t--> Press button S1 [5 sec] ... \n\r"
BTN_TESTS["3,9"]="\t--> Press button S2 [5 sec] ... \n\r"
BTN_TESTS["1,17"]="\t--> Press button S3 [5 sec] ... \n\r"

# Function to simulate checking LEDs
test_leds() {
    for key in "${!LED_TESTS[@]}"; do
        echo -e "${LED_TESTS[$key]}"
        while true; do
            read -r -n 1 -p "" response
            echo ""
            if [[ "$response" == "y" || "$response" == "Y" ]]; then
                break
            elif [[ "$response" == "n" || "$response" == "N" ]]; then
                return 1
            fi
        done
    done

    # Simulate button checks
    for key in "${!BTN_TESTS[@]}"; do
        echo -e "${BTN_TESTS[$key]}"
        echo "Please press the button now and hold for 5 seconds..."
        sleep 5
        # This is a placeholder. In a real script, you would replace this
        # with actual logic to check the button state.
        echo "Assuming button was pressed."
    done
test_leds
check_display
