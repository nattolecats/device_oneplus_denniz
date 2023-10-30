#!/bin/bash

DEVICE=denniz
VENDOR=oneplus

export originalPath=$(pwd)
export branch="evo/udc"

if [ $(pwd) == "${ANDROID_BUILD_TOP}" ] ; then export originalPath=$(pwd)/device/$VENDOR/$DEVICE/patches/ ; fi

discardPatches() {
    cd $originalPath
    for i in $(ls -d */); do
        cd $originalPath
        path=$(tr _ / <<< "$i")
        cd ./../../../../"$path"
        
        git reset --hard $branch 2>/dev/null
    done
}

discardPatches

echo -e "\e[36m* Discard patches done!\e[m"

sleep 1
