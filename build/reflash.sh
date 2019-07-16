#!/bin/bash

# --------------------------------
# - VARIABLES
# --------------------------------

SERIAL_PORT=0
BASE_DIR=$(cd `dirname $0`; pwd)
PROJECT_DIR=$(dirname "$BASE_DIR")

# --------------------------------
# - FUNCTIONS
# --------------------------------

function repaint () {
    clear
    echo -e "
                       __ _           _
 _ __ ___   ___ _   _ / _| | __ _ ___| |__   ___ _ __
| '_ ' _ \ / __| | | | |_| |/ _' / __| '_ \ / _ \ '__|
| | | | | | (__| |_| |  _| | (_| \__ \ | | |  __/ |
|_| |_| |_|\___|\__,_|_| |_|\__,_|___/_| |_|\___|_|
    "
    echo -e ""
    echo -e "\033[35mWelcome to use mcuflasher.\033[0m"
    echo -e "\033[34mby: vincent <wang.yuanqiu007@gmail.com>\033[0m"
    echo -e ""
}

# --------------------------------
# - Find Device
# --------------------------------

repaint
echo -e "\033[33m[-]\033[0m Finding Device ..."
sleep 1

for file in /dev/*
do
    if [[ $file =~ cu.wchusb(.*) ]]; then
        SERIAL_PORT="/dev/${BASH_REMATCH[0]}"
        break
    fi
done

if [ $SERIAL_PORT = 0 ]; then
    repaint
    echo -e "\033[31m[X]\033[0m Cannot find device /dev/cu.wchusb*"
    echo -e ""
    echo -e "Macksure you have installed driver CH340 at './driver/ch34xInstaller.pkg'"
    exit
fi

repaint
echo -e "\033[32m[√]\033[0m Found device '$SERIAL_PORT'"

# --------------------------------
# Erase & Write Flash
# --------------------------------

echo -e "\033[33m[-]\033[0m Reflashing nodemcu firmware ...\n"

esptool.py --port $SERIAL_PORT --baud 115200 --after no_reset write_flash --flash_mode dio 0x00000 "$PROJECT_DIR/firmware/nodemcu.bin" --erase-all

repaint
echo -e "\033[32m[√]\033[0m Found device '$SERIAL_PORT' successfully"
echo -e "\033[32m[√]\033[0m Reflash nodemcu firmware successfully"