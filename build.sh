#!/bin/bash

mkdir bin

nasm -f bin source/bootloader/bootloader.asm -o bin/bootloader.bin
t+ source/kernel/kernel.tplus -o bin/kernel.bin -bin
# t+ source/kernel/kernel.tplus -o kernel.asm

dd if=/dev/zero of=bin/kernel.hdd bs=1024 count=10000
dd if=bin/bootloader.bin of=bin/kernel.hdd conv=notrunc seek=0
dd if=bin/kernel.bin of=bin/kernel.hdd conv=notrunc seek=1

qemu-system-i386 -hda bin/kernel.hdd

rm -rf bin

