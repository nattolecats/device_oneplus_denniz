#!/bin/sh

# Guard
if ! history | tail -n 1 | grep -q "evolution_denniz"; then 

	croot
	cd build/soong  && git reset --hard
	
	croot
	cd frameworks/av && git reset --hard
	
	croot
	cd frameworks/base && git reset --hard
	
	croot
	cd frameworks/native && git reset --hard
	
	croot
	cd packages/modules/Bluetooth && git reset --hard
	
	croot
	return
	
fi

# Give it officiality
export EVO_BUILD_TYPE=OFFICIAL

# Go to root of source
croot

# Prebuilt apps
PA=packages/apps/prebuilt-apps/prebuilt-apps.mk
if ! [ -a $PA ]; then git clone https://github.com/nattolecats/packages_apps_prebuilt-apps packages/apps/prebuilt-apps/ ; fi

# Firmware images
FW=vendor/firmware/denniz/firmware.mk
if ! [ -a $FW ]; then git clone https://github.com/nattolecats/vendor_firmware_denniz vendor/firmware/denniz ; fi

# Source Patches
PATCH=vendor/oneplus/denniz-patches/applyPatchesV2.sh
if ! [ -a $PATCH ]; then git clone https://github.com/oneplus-mt6893-devs/prebuilt_vendor_oneplus_denniz-patches vendor/oneplus/denniz-patches ; fi

# Apply it.
cd vendor/oneplus/denniz-patches/ ; bash applyPatchesV2.sh

cd - > /dev/null

return