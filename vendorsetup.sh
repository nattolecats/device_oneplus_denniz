#!/bin/sh

# Memory the current directory
CUR_DIR=$(pwd)

croot && export ANDROID_BUILD_TOP=$(pwd)

# Download Source Patches
PATCH=vendor/oneplus/denniz-patches/functions.sh
if ! [ -a $PATCH ]; then git clone https://github.com/nattolecats/vendor_oneplus_denniz-patches vendor/oneplus/denniz-patches ; fi

# Include common patching functions
source vendor/oneplus/denniz-patches/functions.sh

# Discard existing patches
discardPatches

# Guard
if ! history | tail -n 1 | grep -q "evolution_denniz"; then return; fi

# Give it officiality
export EVO_BUILD_TYPE=OFFICIAL

# Go to root of source
cd "$ANDROID_BUILD_TOP"

# Prebuilt apps
PA=packages/apps/prebuilt-apps/prebuilt-apps.mk
if ! [ -a $PA ]; then git clone https://github.com/nattolecats/packages_apps_prebuilt-apps packages/apps/prebuilt-apps ; fi

# Firmware images
FW=vendor/firmware/denniz/firmware.mk
if ! [ -a $FW ]; then git clone https://github.com/nattolecats/vendor_firmware_denniz vendor/firmware/denniz ; fi

# Hack MTK RIL libs for USSD and incoming calls
# see https://github.com/phhusson/treble_experimentations/issues/57#issuecomment-416998086
BLOB_ROOT="$ANDROID_BUILD_TOP"/vendor/oneplus/denniz/proprietary

for blob in $BLOB_ROOT/lib64/libmtk-ril.so; do
    sed -i \
        -e 's/AT+EAIC=2/AT+EAIC=3/g' \
        $blob
done

# Apply it.
applyPatches

# Return cd to memoried directory
cd $CUR_DIR ; unset CUR_DIR

return
