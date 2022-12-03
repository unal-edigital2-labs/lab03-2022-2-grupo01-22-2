#!/bin/bash

./load.py
echo 'Load done'
echo '================================'
cd firmware
make clean
make all
echo 'make done'
echo '================================'
echo 'pulse el boton reset del procesador para cargar el firmware'
echo '================================'
cd .. 
litex_term /dev/ttyUSB1 --kernel firmware/firmware.bin
