#!/bin/bash

# PlatinumOS Minimal Edition build script for Linux

RED='\033[31m'
NC='\033[0m'

failed() {
    local message="$1"
    echo -e "${RED}[ FAILED ]${NC} ${message}"
    exit 1
}

check() {
    if [ $? -ne 0 ]; then
        failed "$1"
    fi
}

echo "Building PlatinumOS Minimal Edition..."

# Deleting folders
rm -rf bin
rm -rf img

# Creating folders
mkdir bin
mkdir img

# Compiling bootloader
echo "Compiling bootloader... (boot.asm => bin/BOOT.BIN)"
nasm -f bin boot.asm -o bin/BOOT.BIN
check "Bootloader compilation failed"

# Compiling kernel
echo "Compiling kernel... (kernel.asm => KERNEL.BIN)"
nasm -f bin kernel.asm -o bin/KERNEL.BIN
check "Kernel compilation failed"

# Creating empty disk image
echo "Creating empty disk image... (img/platinumos.img)"
dd if=/dev/zero of=img/platinumos.img bs=512 count=2880 conv=notrunc status=none
check "Disk creation failed"

# Copying bootloader
echo "Copying bootloader to the disk image..."
dd status=none if=bin/BOOT.BIN of=img/platinumos.img conv=notrunc
check "Bootloader copying failed"

# Copying kernel
echo "Copying kernel to the disk image..."
dd if=bin/KERNEL.BIN of=img/platinumos.img bs=512 seek=33 conv=notrunc status=none
check "Kernel copying failed"

echo "Build complete!"

BOOT_SIZE=$(stat -c%s bin/BOOT.BIN)
KERNEL_SIZE=$(stat -c%s bin/KERNEL.BIN)
IMAGE_SIZE=$(stat -c%s img/platinumos.img)

echo "Bootloader: $BOOT_SIZE bytes"
echo "Kernel: $KERNEL_SIZE bytes"
echo "Disk image: $IMAGE_SIZE bytes"