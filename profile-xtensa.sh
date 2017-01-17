export PATH=$PATH:/opt/xtensa-lx106-elf/bin/
export PICODILLY_BUILD_ROOT=/opt/xtensa-lx106-dev

# default settings for esp-open-rtos
# find more information at https://github.com/SuperHouse/esp-open-rtos
export EXTRA_CFLAGS="-I$PICODILLY_BUILD_ROOT/include"
export EXTRA_LDFLAGS="-L$PICODILLY_BUILD_ROOT/lib"