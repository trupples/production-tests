SCRIPT_DIR="$(readlink -f $(dirname $0))"

source $SCRIPT_DIR/test_util.sh

function find_hwmon() {
        for hwmonx in /sys/class/hwmon/*; do
                if grep -sq "$1" "$hwmonx/name"; then
                        echo $hwmonx
                        return
                fi
        done
}

ADT7422_HWMON=$(find_hwmon adt7422)

TEST_NAME="TEST_ADT7422"

TEST_ID="01"
SHORT_DESC="Checking for adt7422"
CMD="dtoverlay -r && dtoverlay $SCRIPT_DIR/rpi-ad9545-hmc7044.dtbo;"
CMD+="cat $ADT7422_HWMON/name | grep adt7422"
run_test $TEST_ID "$SHORT_DESC" "$CMD"

TEST_ID="02"
SHORT_DESC="Checking for temperature"
CMD="TEMP=\$(cat $ADT7422_HWMON/temp1_input);"
CMD+="cat $ADT7422_HWMON/temp1_input;"
CMD+="[[ \$TEMP -ge 25000 ]] && [[ \$TEMP -le 80000 ]]"
run_test $TEST_ID "$SHORT_DESC" "$CMD"
