BOOT_SRC = boot/boot.asm
BOOT_BIN = boot/boot.bin
IMG = calc.img

all: $(IMG)

$(BOOT_BIN): $(BOOT_SRC)
	nasm -f bin $(BOOT_SRC) -o $(BOOT_BIN)

$(IMG): $(BOOT_BIN)
	cp $(BOOT_BIN) $(IMG)

run: $(IMG)
	qemu-system-x86_64 -fda $(IMG)

clean:
	rm -f $(BOOT_BIN) $(IMG)
