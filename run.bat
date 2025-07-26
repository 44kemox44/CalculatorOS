@echo off
setlocal

:: 1. Projeyi bulunduğu dizine al
cd /d %~dp0

:: 2. Boot.asm derle
echo [1/4] Derleniyor: boot.asm
nasm -f bin boot\boot.asm -o boot\boot.bin
if %errorlevel% neq 0 (
    echo ❌ boot.asm derlenemedi!
    pause
    exit /b
)

:: 3. kernel.c derle
echo [2/4] Derleniyor: kernel.c
if not exist kernel\ (
    echo ❌ kernel klasörü bulunamadı!
    pause
    exit /b
)

:: i686-w64-mingw32-gcc ile derle
/mingw32/bin/i686-w64-mingw32-gcc -ffreestanding -m32 -c kernel\kernel.c -o kernel\kernel.o
if %errorlevel% neq 0 (
    echo ❌ kernel.c derlenemedi!
    pause
    exit /b
)

:: 4. kernel.o → kernel.bin linkle
echo [3/4] kernel.bin oluşturuluyor
/mingw32/bin/i686-w64-mingw32-ld -T kernel\linker.ld kernel\kernel.o -o kernel\kernel.bin -nostdlib
if %errorlevel% neq 0 (
    echo ❌ kernel.bin link hatası!
    pause
    exit /b
)

:: 5. boot + kernel → imaj oluştur
echo [4/4] calc.img oluşturuluyor
copy /b boot\boot.bin + kernel\kernel.bin calc.img >nul

:: 6. QEMU ile başlat
qemu-system-x86_64 -fda calc.img

pause
endlocal
