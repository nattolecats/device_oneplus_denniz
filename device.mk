#
# Copyright (C) 2020 Android Open Source Project
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

DEVICE_PATH := device/oneplus/denniz

# Installs gsi keys into ramdisk, to boot a developer GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)

# Enable updatable APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# VNDK
PRODUCT_EXTRA_VNDK_VERSIONS := 30

PRODUCT_SHIPPING_API_LEVEL := 30

# Call proprietary blob setup
$(call inherit-product, vendor/oneplus/denniz/denniz-vendor.mk)
$(call inherit-product, vendor/oneplus/IMS-denniz/mtk-ims.mk)
$(call inherit-product-if-exists, packages/apps/prebuilt-apps/prebuilt-apps.mk)

# Dynamic Partition
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

# OneplusParts
$(call inherit-product, packages/apps/OneplusParts/parts.mk)

# OPlusExtras
PRODUCT_PACKAGES += \
    OPlusExtras \
    tri-state-key-calibrate

# CameraGo
PRODUCT_PACKAGES += \
    GCamGOPrebuilt-V4

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/oneplus/denniz/bluetooth/include

# Bluetooth Audio (System-side HAL, sysbta)
PRODUCT_PACKAGES += \
    audio.sysbta.default \
    android.hardware.bluetooth.audio-service-system

PRODUCT_COPY_FILES += \
    device/oneplus/denniz/bluetooth/audio/config/sysbta_audio_policy_configuration.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysbta_audio_policy_configuration.xml \
    device/oneplus/denniz/bluetooth/audio/config/sysbta_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUTY_SYSTEM)/etc/sysbta_audio_policy_configuration_7_0.xml

# Carrier Config Overlays
PRODUCT_PACKAGES += \
    CarrierConfigOverlay

# Dex
PRODUCT_DEXPREOPT_SPEED_APPS += \
    Settings \
    SystemUI

# DT2W
PRODUCT_PACKAGES += \
    DT2W-Service-denniz

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/vendor_overlay/etc/fstab.mt6893:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6893

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.3-service.denniz \
	vendor.oplus.hardware.biometrics.fingerprint@2.1

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.fingerprint.xml

# Freeform Multiwindow
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml

# HIDL
PRODUCT_PACKAGES += \
    libhidltransport \
    libhardware \
    libhwbinder

# ImsInit hack
PRODUCT_PACKAGES += \
    ImsInit

# Init
PRODUCT_PACKAGES += \
    init.mt6893.rc \
    init.oplus_extras.rc

# NFC
PRODUCT_PACKAGES += \
    com.android.nfc_extras \
    com.gsma.services.nfc  \
    NfcNci \
    SecureElement \
    Tag

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/nfc/libnfc-nxp.conf:$(TARGET_COPY_OUT_SYSTEM)/etc/libnfc-nxp.conf

# Pocket Mode
PRODUCT_PACKAGES += \
    PocketMode

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/permissions/privapp-permissions-pocketmode.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-pocketmode.xml

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Input
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/keylayout/mt63xx-accdet_Headset.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/mt63xx-accdet_Headset.kl

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service.denniz \
    android.hardware.sensors@2.0-service-multihal.denniz

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(DEVICE_PATH)/overlay \
    $(DEVICE_PATH)/overlay-evolution

# MTK IMS Overlays
PRODUCT_PACKAGES += \
    mtk-ims \
    mtk-ims-telephony

# MTK InCallService
PRODUCT_PACKAGES += \
    MtkInCallService

# Permissions
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/permissions/privapp-permissions-mediatek.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-mediatek.xml

# Perf
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
    $(DEVICE_PATH)/configs/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json

# Recovery
PRODUCT_PACKAGES += \
    init.recovery.mt6893.rc \
    init.recovery.mt6893.sh

# RcsService
PRODUCT_PACKAGES += \
    com.android.ims.rcsmanager \
    RcsService \
    PresencePolling

# Remove unwanted packages
PRODUCT_PACKAGES += \
    RemovePkgs

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# System prop
PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

# Symbols
PRODUCT_PACKAGES += \
    libshim_vtservice

# Touch
PRODUCT_PACKAGES += \
    vendor.lineage.touch@1.0-service.denniz

# Vendor overlay
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/vendor_overlay/,$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/30/)

# Udfps
PRODUCT_PACKAGES += \
    UdfpsResources

# Wi-Fi
PRODUCT_PACKAGES += \
    TetheringConfigOverlay \
    WifiOverlay

# Manifest
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/configs/manifest.xml

# AOD Custom implements
PRODUCT_PACKAGES += AODHelper
