"""
Run on AD-VIPER-SL to initialize MAX96724 - MAX96717 - IMX219 (rpi camera v2) with test pattern (not live video)
/dev/video2, 1920x1080, RGGB
"""

import sys
sys.path.append('./python_libs')

from gmsl_lib import config_loader
from smbus2 import SMBus

I2C_BUS_NR = 1
IN_FILES = [
    'MAX96724_INT_MAX96717_IMX219_2_lanes_RAW8_1500.cpp',
    'imx219_raw8_1920_1080_tpg_programming.cpp',
]

bus = SMBus(I2C_BUS_NR)

c = config_loader.GMSLConfig(bus, IN_FILES)
c.load()

bus.close()
print('Done configuring GMSL')

