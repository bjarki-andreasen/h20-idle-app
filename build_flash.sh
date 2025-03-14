#!/bin/bash

# Usage:
#
#     Call from workspace folder:
#
#     ./build_flash.sh
#
#     When switching between upstream and NCS, use recover option to reflash manifest and BICR
#
#     ./build_flash.sh recover <serial number>

set -e

if [ $1 == 'recover' ]; then
    if [ $# != 2 ]; then
        echo 'please provide serial number from listed devices:'
        echo ''
        nrfutil device list
        exit 1
    fi
        nrfutil device x-boot-mode-set --boot-mode safe --traits jlink --serial-number $2
        nrfutil device erase --all --traits jlink --log-level trace --core Application --serial-number $2
        nrfutil device erase --all --traits jlink --log-level trace --core Network --serial-number $2
        nrfutil device x-boot-mode-set --boot-mode normal --traits jlink --serial-number $2
        nrfutil device program --firmware ./modules/hal/nordic/zephyr/blobs/suit/bin/suit_manifest_starter.hex --serial-number $2
fi

# Build app
west build -p -b nrf54h20dk/nrf54h20/cpuapp --no-sysbuild h20-idle-app

# Flash BICR if recover
if [ $1 == recover ]; then
    nrfutil device program --options chip_erase_mode=ERASE_NONE --firmware ./build/zephyr/bicr.hex --core Application --serial-number $2
fi

# Flash cpuapp
west flash

# Build and flash cpurad
west build -p -b nrf54h20dk/nrf54h20/cpurad --no-sysbuild h20-idle-app
west flash

echo 'done'
