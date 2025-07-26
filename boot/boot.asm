[org 0x7c00]

start:
    ; ES register'ını sıfırla, BX ile birlikte 0x0000:0x1000 adresini hedefle
    mov ax, 0x0000
    mov es, ax
    mov bx, 0x1000      ; Kernel'in yükleneceği bellek adresi (offset)

    ; Ekrana başlangıç mesajını yazdır
    mov si, boot_msg
    call print_string

    ; Kernel'i diskten belleğe yükle
    mov ah, 0x02        ; BIOS disk okuma fonksiyonu
    mov al, 1           ; Okunacak sektör sayısı (kernel şimdilik 512 byte'tan küçük)
    mov ch, 0           ; Silindir no
    mov cl, 2           ; Başlangıç sektör no (1. sektör bootloader, 2. kernel)
    mov dh, 0           ; Kafa no
    ; ES:BX (0x0000:0x1000) zaten ayarlı

    int 0x13            ; Disk okuma interrupt'ı
    jnc .load_success   ; Hata yoksa (Carry Flag = 0) atla. BU SATIR ÖNEMLİ!

.disk_error:
    mov si, error_msg   ; Hata varsa hata mesajını yazdır
    call print_string
    jmp $               ; Sonsuz döngüde sistemi kilitle

.load_success:
    jmp 0x0000:0x1000   ; Her şey yolundaysa kernel'e atla

; Ekrana null-terminated string yazdıran fonksiyon
print_string:
    lodsb               ; SI'dan bir byte AL'ye yükle, SI'yı artır
    or al, al           ; AL sıfır mı diye kontrol et (string sonu mu?)
    jz .done
    mov ah, 0x0e        ; Teletype fonksiyonu
    int 0x10            ; Video interrupt'ı
    jmp print_string
.done:
    ret

; Veriler
boot_msg db "CalculatorOS booted! Starting kernel...", 13, 10, 0
error_msg db "Disk read error!", 13, 10, 0

; Bootloader'ı 512 byte'a tamamla ve boot edilebilir yap
times 510 - ($ - $$) db 0
dw 0xaa55