#!/bin/bash

python3 init_717mipi_tpg.py
sleep 1
rm frame
timeout 1 v4l2-ctl --device /dev/video2 --set-fmt-video=width=1920,height=1080,pixelformat=RGGB --stream-mmap --stream-to=frame --stream-count=1
md5sum frame | grep -q 6533afad5f4f8824ec19c56d086bdf66

