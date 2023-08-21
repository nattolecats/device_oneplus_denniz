#
# Copyright (C) 2021 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit from device makefile
$(call inherit-product, device/oneplus/denniz/device.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device identifier. This must come after all inclusions.
PRODUCT_NAME := lineage_denniz
PRODUCT_DEVICE := denniz
PRODUCT_BRAND := OnePlus
PRODUCT_MODEL := DN2103
PRODUCT_MANUFACTURER := OnePlus

# Gapps
TARGET_GAPPS_ARCH := arm64
TARGET_BOOT_ANIMATION_RES := 1080
TARGET_SUPPORTS_QUICK_TAP := true

PRODUCT_GMS_CLIENTID_BASE := android-oneplus

# Rising stuff
RISING_CHIPSET := "MediaTek Dimensity 1200-AI"
RISING_MAINTAINER := "lahaina"
RISING_PACKAGE_TYPE := AOSP
TARGET_BUILD_APERTURE_CAMERA := false
TARGET_ENABLE_BLUR := false
TARGET_HAS_UDFPS := true
TARGET_USE_PIXEL_FINGERPRINT := false
TARGET_USE_GOOGLE_TELEPHONY := true
TARGET_CORE_GMS_EXTRAS := true

# Build info
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_DEVICE=OP515BL1 \
    PRODUCT_NAME=DN2103 \
    PRIVATE_BUILD_DESC="DN201IND-user 11 RP1A.200720.011 1627567766349 release-keys"

BUILD_FINGERPRINT := OnePlus/DN2103/OP515BL1:11/RP1A.200720.011/1627567766349:user/release-keys
