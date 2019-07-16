#!/bin/bash

SERIAL_PORT=0
BASE_DIR=$(cd `dirname $0`; pwd)
PROJECT_DIR=$(dirname "$BASE_DIR")
SOURCE_DIR="$PROJECT_DIR/src"

for file in /dev/*
do
    if [[ $file =~ cu.wchusb(.*) ]]; then
        SERIAL_PORT="/dev/${BASH_REMATCH[0]}"
        break
    fi
done

echo -e "\033[32m[√]\033[0m Upload files \n"

for file in $SOURCE_DIR/*.lua
do
    nodemcu-uploader -p $SERIAL_PORT upload $file:${file##*/}
done