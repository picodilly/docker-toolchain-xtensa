# ensure that the xtensa toochain is in the search path
export PATH=$PATH:/opt/xtensa-lx106-elf/bin/

# directory for crosscompiled xtensa libraries and includes
export PICODILLY_BUILD_ROOT=/opt/xtensa-lx106-dev

# default settings for esp-open-rtos
# find more information at https://github.com/SuperHouse/esp-open-rtos
export EXTRA_CFLAGS="-I$PICODILLY_BUILD_ROOT/include"
export EXTRA_LDFLAGS="-L$PICODILLY_BUILD_ROOT/lib"

# add support for NodeMCU
# find more information at https://github.com/nodemcu/nodemcu-firmware
export EXTRA_CCFLAGS=$EXTRA_CFLAGS
export ESPTOOL=/usr/bin/esptool.py
