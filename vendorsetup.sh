#!/bin/bash

PROTON=prebuilts/clang/host/linux-x86/proton/bin/ld
if ! [ -a $PROTON ]; then
    git clone https://github.com/kdrag0n/proton-clang prebuilts/clang/host/linux-x86/proton --depth 1
fi
