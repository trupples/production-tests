#!/bin/bash

# Prepare setup required to run python scripts for carrier, instead of installing them directly there, because it may not have an internet connection

(
git clone --single-branch --branch tools https://github.com/analogdevicesinc/gmsl -- gmsl-tools &&
mv gmsl-tools/AD-GMSL522-SL/python-loader-scripts/gmsl_lib ./gmsl_lib
) &
(git clone https://github.com/kplindegaard/smbus2 -- python-smbus2 && 
mkdir python_libs
mv python-smbus2/smbus2 python_libs/smbus2
) &
wait
rm -rf gmsl-tools python-smbus2

