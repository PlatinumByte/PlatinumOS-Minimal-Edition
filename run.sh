#!/bin/bash

echo "Starting emulator..."

qemu-system-x86_64 \
    -display gtk \
    -fda img/platinumos.img \
    -machine pcspk-audiodev=snd0 \
    -device adlib,audiodev=snd0 \
    -audiodev pa,id=snd0