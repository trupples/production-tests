#!/bin/bash

SCRIPT_DIR="$(readlink -f $(dirname $0))"
source $SCRIPT_DIR/../lib/utils.sh

#RELEASE_FW=https://swdownloads.analog.com/cse/prod_test_rel/ev_charger_fw/ad-acevsecrdset-sl.zip
FW_DOWNLOAD_PATH=/home/analog/production-tests/main_tests/pqm

# cp the hex file to daplink
#wget -T 5 $RELEASE_FW -O $FW_DOWNLOAD_PATH/ad-acevsecrdset-sl.zip
#unzip $FW_DOWNLOAD_PATH/ad-acevsecrdset-sl.zip -d $FW_DOWNLOAD_PATH
ret=$?

if [ $ret == 0 ];then
    echo "wget success"
    daplink_upload $FW_DOWNLOAD_PATH/pqm_prod_test.hex
else
    echo "wget error"
    daplink_upload /home/analog/production-tests/main_tests/pqm/pqm_prod_test.hex
fi
