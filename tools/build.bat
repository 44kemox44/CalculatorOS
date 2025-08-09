@echo off

set QEMU_PATH="E:\Program Files\qemu\qemu-system-x86_64.exe"

echo Bootloader derleniyor...
nasm bootloader/boot.s -f bin -o CalculatorOS.img

echo QEMU ile calistiriliyor...
%QEMU_PATH% -fda CalculatorOS.img