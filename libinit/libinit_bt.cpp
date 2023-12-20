/*
 * Copyright (C) 2023 The Evolution X Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_utils.h>

#include <libinit_bt.h>

static const char *bt_prop_key[] = {
    "persist.bluetooth.a2dp_offload.disabled",
    "ro.bluetooth.a2dp_offload.supported",
    "persist.bluetooth.system_audio_hal.enabled",
    NULL
};

static const char *bt_prop_value[] = {
    "true",
    "false",
    "1",
    NULL
};

void set_bt_props() {
    // Force override Bluetooth props
    for (int i = 0; bt_prop_key[i]; ++i) {
        property_override(bt_prop_key[i], bt_prop_value[i]);
    }
}
