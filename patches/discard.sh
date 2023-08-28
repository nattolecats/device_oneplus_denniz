#!/bin/bash

export originalPath=$(pwd)
export branch="arrow/arrow-13.1"

discardPatches() {
    for i in $(ls -d */); do
        cd $originalPath
        path=$(tr _ / <<< "$i")
        cd ./../../../../"$path"
        
        git reset --hard $branch
    done
}

discardPatches

echo -e "\e[36m* Discard patches done!\e[m"

sleep 1
