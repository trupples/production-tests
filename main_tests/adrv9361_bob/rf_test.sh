ANSWER=1

SCRIPT_DIR="$(readlink -f $(dirname $0))"

echo
python3 -m pytest --color yes -vs $SCRIPT_DIR/../work/pyadi-iio/test/test_adrv9361_prod.py --uri="ip:analog.local" --adi-hw-map --hw=adrv9361
ANSWER=$?
exit $ANSWER
