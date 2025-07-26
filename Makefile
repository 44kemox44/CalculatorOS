# Makefile for CalculatorOS

# ARAÇLAR: KESİNLİKLE BU ŞEKİLDE OLMALI
CC = i686-w64-mingw32-gcc
LD = i686-w64-mingw32-ld
NASM = nasm

# Proje dosyaları
BOOT_SRC = boot/boot.asm
KERNEL_C_SRC = kernel/kernel.c
LINKER_SCRIPT = kernel/linker.ld

# Çıktı dosyaları
BOOT_BIN = boot/boot.bin
KERNEL_OBJ = kernel/kernel.o
KERNEL_BIN = kernel/kernel.bin
OS_IMG = CalculatorOS.img

# Ana hedef
all: $(OS_IMG)

# İşletim sistemi imajını oluşturur
# DİKKAT: 'copy /b' yerine 'cat' kullanılıyor
$(OS_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	@echo "Creating OS image..."
	cat $(BOOT_BIN) $(KERNEL_BIN) > $(OS_IMG)

# Bootloader'ı derler
$(BOOT_BIN): $(BOOT_SRC)
	@echo "Assembling bootloader..."
	$(NASM) -f bin $(BOOT_SRC) -o $(BOOT_BIN)

# Kernel C kodunu object dosyasına derler
$(KERNEL_OBJ): $(KERNEL_C_SRC)
	@echo "Compiling kernel..."
	$(CC) -ffreestanding -m32 -c $(KERNEL_C_SRC) -o $(KERNEL_OBJ)

# Kernel object dosyasını linker script ile birleştirerek binary oluşturur
# DİKKAT: $(LD) değişkeni kullanılıyor
$(KERNEL_BIN): $(KERNEL_OBJ) $(LINKER_SCRIPT)
	@echo "Linking kernel..."
	$(LD) -nostdlib -T $(LINKER_SCRIPT) -o $(KERNEL_BIN) $(KERNEL_OBJ)

# QEMU ile çalıştırır
run: all
	"E:/Program Files/qemu/qemu-system-i386.exe" -fda $(OS_IMG)

# Temizlik
# DİKKAT: Windows 'del' yerine Unix 'rm -f' kullanılıyor
clean:
	@echo "Cleaning up..."
	rm -f $(BOOT_BIN) $(KERNEL_OBJ) $(KERNEL_BIN) $(OS_IMG)