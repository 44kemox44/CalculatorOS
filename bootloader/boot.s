; bootloader/boot.s
; --------------------------------------------------

bits 16
org 0x7c00

start:
    ; Stack'ı ayarla
    mov ax, 0x07c0
    mov ss, ax
    mov sp, ax

    ; Ekrana bir mesaj yazdıralım.
    mov si, msg
    call print_string

    jmp $ ; Sonsuz döngü

print_string:
    mov ah, 0x0e
.loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .loop
.done:
    ret

msg:
    db "CalculatorOS'a hos geldin!", 0

; Kalan kısmı 0x00 ile doldur ve Boot Signature'ı ekle
times 510 - ($ - $$) db 0
dw 0xaa55