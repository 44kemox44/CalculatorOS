@echo off
cd /d %~dp0
nasm -f bin boot\boot.asm -o boot\boot.bin
copy /Y boot\boot.bin calc.img >nul
qemu-system-x86_64 -fda calc.img
pause
