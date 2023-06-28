#!/bin/sh

# Memory the current directory
CUR_DIR=$(pwd)

croot && export ANDROID_BUILD_TOP=$(pwd)

# Include common patching functions
source vendor/oneplus/denniz-patches/functions.sh

# Discard existing patches
discardPatches

# Go to root of source
cd "$ANDROID_BUILD_TOP"

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
